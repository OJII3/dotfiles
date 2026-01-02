#!/usr/bin/env python3
"""
Advanced Touchpad Filter Daemon

Features:
- Mac-like cursor acceleration (faster movement = exponentially more distance)
- Strict 2-finger scroll (both fingers must move in same direction)
"""

import sys
import evdev
from evdev import InputDevice, UInput, ecodes as e, AbsInfo
import argparse
from collections import defaultdict
import math


class TouchpadFilter:
    def __init__(self, device_path, debug=False):
        self.debug = debug
        self.device = InputDevice(device_path)
        self.log(f"Listening to: {self.device.name}")

        # Grab the device to prevent other programs from receiving events
        self.device.grab()

        # Multi-touch tracking
        self.slots = defaultdict(lambda: {'tracking_id': -1, 'x': 0, 'y': 0, 'prev_x': 0, 'prev_y': 0})
        self.current_slot = 0
        self.active_fingers = 0

        # 1-finger cursor movement state
        self.cursor_active = False

        # 2-finger scroll state
        self.scroll_finger_1 = None
        self.scroll_finger_2 = None
        self.last_scroll_dx = 0
        self.last_scroll_dy = 0

        # Acceleration curve parameters (Mac-like)
        self.accel_base = 1.0  # Base multiplier
        self.accel_sensitivity = 0.015  # How much speed affects acceleration
        self.accel_exponent = 1.6  # Exponential curve (higher = more aggressive)

        # Get touchpad capabilities
        caps = self.device.capabilities(absinfo=True)

        # Create virtual input device
        virtual_caps = {
            e.EV_KEY: [e.BTN_LEFT, e.BTN_RIGHT, e.BTN_MIDDLE],
            e.EV_REL: [e.REL_X, e.REL_Y, e.REL_WHEEL, e.REL_HWHEEL],
        }

        # Add absolute position if available (for touchpad)
        if e.EV_ABS in caps:
            virtual_caps[e.EV_ABS] = []
            for code, absinfo in caps[e.EV_ABS]:
                if code in [e.ABS_MT_POSITION_X, e.ABS_MT_POSITION_Y,
                           e.ABS_MT_TRACKING_ID, e.ABS_MT_SLOT]:
                    virtual_caps[e.EV_ABS].append((code, absinfo))

        self.vdevice = UInput(virtual_caps, name="Virtual Touchpad Filter")
        self.log("Virtual device created")

    def log(self, msg):
        if self.debug:
            print(f"[TouchpadFilter] {msg}", file=sys.stderr)

    def count_active_fingers(self):
        """Count how many fingers are currently touching"""
        count = 0
        for slot_data in self.slots.values():
            if slot_data['tracking_id'] != -1:
                count += 1
        return count

    def get_active_slots(self):
        """Get list of active slot numbers"""
        active = []
        for slot_num, slot_data in self.slots.items():
            if slot_data['tracking_id'] != -1:
                active.append(slot_num)
        return sorted(active)

    def calculate_center(self, slot_nums):
        """Calculate center point of multiple touch points"""
        if not slot_nums:
            return 0, 0

        total_x = sum(self.slots[s]['x'] for s in slot_nums)
        total_y = sum(self.slots[s]['y'] for s in slot_nums)
        return total_x // len(slot_nums), total_y // len(slot_nums)

    def calculate_movement(self, slot_num):
        """Calculate movement delta for a slot"""
        slot = self.slots[slot_num]
        dx = slot['x'] - slot['prev_x']
        dy = slot['y'] - slot['prev_y']
        return dx, dy

    def same_direction(self, dx1, dy1, dx2, dy2, threshold=10):
        """Check if two movements are in the same direction"""
        # If both movements are too small, ignore
        mag1 = math.sqrt(dx1**2 + dy1**2)
        mag2 = math.sqrt(dx2**2 + dy2**2)

        if mag1 < threshold or mag2 < threshold:
            return True  # Allow small movements

        # Check if vectors point in similar direction
        dot_product = dx1 * dx2 + dy1 * dy2

        # If dot product is positive, they're in similar direction
        return dot_product > 0

    def apply_acceleration_curve(self, dx, dy):
        """Apply Mac-like acceleration curve to cursor movement"""
        # Calculate speed (magnitude of movement)
        speed = math.sqrt(dx**2 + dy**2)

        if speed < 0.1:
            return 0, 0

        # Apply acceleration curve: multiplier = base + sensitivity * speed^exponent
        multiplier = self.accel_base + self.accel_sensitivity * (speed ** self.accel_exponent)

        # Apply multiplier to movement
        accel_dx = int(dx * multiplier)
        accel_dy = int(dy * multiplier)

        self.log(f"Acceleration: speed={speed:.1f}, mult={multiplier:.2f}, ({dx},{dy}) -> ({accel_dx},{accel_dy})")

        return accel_dx, accel_dy

    def handle_1finger_cursor(self):
        """Handle 1-finger cursor movement with Mac-like acceleration"""
        active = self.get_active_slots()

        if len(active) != 1:
            self.cursor_active = False
            return False  # Not a 1-finger gesture

        slot = active[0]

        # Calculate movement
        dx, dy = self.calculate_movement(slot)

        # Update previous position
        self.slots[slot]['prev_x'] = self.slots[slot]['x']
        self.slots[slot]['prev_y'] = self.slots[slot]['y']

        # Apply acceleration curve
        accel_dx, accel_dy = self.apply_acceleration_curve(dx, dy)

        # Send cursor movement
        if accel_dx != 0 or accel_dy != 0:
            self.vdevice.write(e.EV_REL, e.REL_X, accel_dx)
            self.vdevice.write(e.EV_REL, e.REL_Y, accel_dy)
            self.vdevice.syn()
            self.cursor_active = True

        return True  # Event handled

    def handle_2finger_scroll(self):
        """Handle strict 2-finger scroll (both fingers must move in same direction)"""
        active = self.get_active_slots()

        if len(active) != 2:
            self.scroll_finger_1 = None
            self.scroll_finger_2 = None
            return False  # Not a 2-finger gesture, pass through

        slot1, slot2 = active[0], active[1]

        # Calculate movement for each finger
        dx1, dy1 = self.calculate_movement(slot1)
        dx2, dy2 = self.calculate_movement(slot2)

        # Update previous positions
        self.slots[slot1]['prev_x'] = self.slots[slot1]['x']
        self.slots[slot1]['prev_y'] = self.slots[slot1]['y']
        self.slots[slot2]['prev_x'] = self.slots[slot2]['x']
        self.slots[slot2]['prev_y'] = self.slots[slot2]['y']

        # Check if both fingers move in same direction
        if not self.same_direction(dx1, dy1, dx2, dy2):
            self.log("2-finger scroll: fingers moving in different directions, blocked")
            return True  # Block the event

        # Both fingers moving in same direction - allow scroll
        # Average the movement
        dx_avg = (dx1 + dx2) // 2
        dy_avg = (dy1 + dy2) // 2

        if abs(dy_avg) > abs(dx_avg):
            # Vertical scroll
            scroll_amount = -dy_avg // 20  # Scale down and invert
            if scroll_amount != 0:
                self.vdevice.write(e.EV_REL, e.REL_WHEEL, scroll_amount)
                self.vdevice.syn()
                self.log(f"2-finger scroll: vertical {scroll_amount}")
        else:
            # Horizontal scroll
            scroll_amount = dx_avg // 20  # Scale down
            if scroll_amount != 0:
                self.vdevice.write(e.EV_REL, e.REL_HWHEEL, scroll_amount)
                self.vdevice.syn()
                self.log(f"2-finger scroll: horizontal {scroll_amount}")

        return True  # Event handled

    def process_event(self, event):
        """Process a single input event"""
        # Track multi-touch slot data
        if event.type == e.EV_ABS:
            if event.code == e.ABS_MT_SLOT:
                self.current_slot = event.value
            elif event.code == e.ABS_MT_TRACKING_ID:
                self.slots[self.current_slot]['tracking_id'] = event.value
                if event.value == -1:
                    # Finger lifted
                    self.log(f"Finger lifted from slot {self.current_slot}")
                else:
                    # Finger touched
                    self.log(f"Finger touched on slot {self.current_slot}")
            elif event.code == e.ABS_MT_POSITION_X:
                self.slots[self.current_slot]['x'] = event.value
            elif event.code == e.ABS_MT_POSITION_Y:
                self.slots[self.current_slot]['y'] = event.value

        # On SYN event, check for gestures
        if event.type == e.EV_SYN and event.code == e.SYN_REPORT:
            self.active_fingers = self.count_active_fingers()
            self.log(f"Active fingers: {self.active_fingers}")

            # Priority: 2-finger scroll > 1-finger cursor
            if self.active_fingers == 2:
                if self.handle_2finger_scroll():
                    return  # Don't pass through
            elif self.active_fingers == 1:
                if self.handle_1finger_cursor():
                    return  # Don't pass through

        # Pass through all other events
        self.vdevice.write(event.type, event.code, event.value)
        if event.type == e.EV_SYN:
            self.vdevice.syn()

    def run(self):
        """Main event loop"""
        self.log("Starting event loop...")
        try:
            for event in self.device.read_loop():
                self.process_event(event)
        except KeyboardInterrupt:
            self.log("Interrupted by user")
        finally:
            self.cleanup()

    def cleanup(self):
        """Clean up resources"""
        self.log("Cleaning up...")
        self.device.ungrab()
        self.device.close()
        self.vdevice.close()


def find_touchpad():
    """Find the touchpad device automatically"""
    devices = [InputDevice(path) for path in evdev.list_devices()]

    for device in devices:
        # Look for devices with touchpad capabilities
        caps = device.capabilities()

        # Check if it has multi-touch absolute position
        if e.EV_ABS in caps:
            abs_events = [code for code, _ in caps[e.EV_ABS]]
            if e.ABS_MT_POSITION_X in abs_events and e.ABS_MT_POSITION_Y in abs_events:
                # Likely a touchpad
                name_lower = device.name.lower()
                if 'touchpad' in name_lower or 'synaptics' in name_lower or 'elan' in name_lower:
                    return device.path

    return None


def main():
    parser = argparse.ArgumentParser(description="Advanced Touchpad Filter Daemon")
    parser.add_argument('-d', '--device', help='Touchpad device path (e.g., /dev/input/event4)')
    parser.add_argument('-v', '--verbose', action='store_true', help='Enable debug logging')
    parser.add_argument('--list-devices', action='store_true', help='List all input devices and exit')

    args = parser.parse_args()

    if args.list_devices:
        print("Available input devices:")
        for path in evdev.list_devices():
            device = InputDevice(path)
            print(f"  {path}: {device.name}")
        return

    device_path = args.device

    if not device_path:
        device_path = find_touchpad()
        if not device_path:
            print("Error: Could not find touchpad device automatically.", file=sys.stderr)
            print("Please specify device path with --device option.", file=sys.stderr)
            print("Use --list-devices to see available devices.", file=sys.stderr)
            sys.exit(1)
        else:
            print(f"Auto-detected touchpad: {device_path}", file=sys.stderr)

    try:
        filter_daemon = TouchpadFilter(device_path, debug=args.verbose)
        filter_daemon.run()
    except PermissionError:
        print("Error: Permission denied. This script requires root privileges or appropriate udev rules.", file=sys.stderr)
        print("Run with sudo or configure udev rules for input devices.", file=sys.stderr)
        sys.exit(1)
    except FileNotFoundError:
        print(f"Error: Device {device_path} not found.", file=sys.stderr)
        sys.exit(1)
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)


if __name__ == '__main__':
    main()
