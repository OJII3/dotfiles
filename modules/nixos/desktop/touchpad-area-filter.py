#!/usr/bin/env python3
"""Ignore touchpad contacts that begin inside a top-edge dead zone."""

import argparse
import logging
import time

from evdev import InputDevice, UInput, ecodes


TOOL_KEYS = {
    1: ecodes.BTN_TOOL_FINGER,
    2: ecodes.BTN_TOOL_DOUBLETAP,
    3: ecodes.BTN_TOOL_TRIPLETAP,
    4: ecodes.BTN_TOOL_QUADTAP,
    5: ecodes.BTN_TOOL_QUINTTAP,
}


class TouchpadFilter:
    def __init__(self, device, output, minimum_y):
        self.device = device
        self.output = output
        self.minimum_y = minimum_y
        slot_info = device.absinfo(ecodes.ABS_MT_SLOT)
        self.slots = [
            {"y": 0, "accepted": False}
            for _ in range(slot_info.max + 1)
        ]
        self.current_slot = slot_info.value
        self.reported_keys = {ecodes.BTN_TOUCH: False}
        self.reported_keys.update((key, False) for key in TOOL_KEYS.values())
        self.forwarded_click = False

    def emit(self, event):
        self.output.write(event.type, event.code, event.value)

    def process_frame(self, events):
        before = [slot["accepted"] for slot in self.slots]
        frame_start_slot = self.current_slot
        frame_slot = frame_start_slot
        new_slots = set()
        lifted_slots = set()

        for event in events:
            if event.type != ecodes.EV_ABS:
                continue
            if event.code == ecodes.ABS_MT_SLOT:
                frame_slot = event.value
            elif event.code == ecodes.ABS_MT_TRACKING_ID:
                if event.value < 0:
                    lifted_slots.add(frame_slot)
                    self.slots[frame_slot]["accepted"] = False
                else:
                    new_slots.add(frame_slot)
                    slot = self.slots[frame_slot]
                    slot["y"] = None
                    slot["accepted"] = False
            elif event.code == ecodes.ABS_MT_POSITION_Y:
                self.slots[frame_slot]["y"] = event.value

        self.current_slot = frame_slot
        for slot_index in new_slots:
            slot = self.slots[slot_index]
            slot["accepted"] = slot["y"] is not None and slot["y"] >= self.minimum_y

        after = [slot["accepted"] for slot in self.slots]
        accepted_count = sum(after)
        has_contact = accepted_count > 0 or any(before)
        frame_slot = frame_start_slot

        for event in events:
            if event.type == ecodes.EV_ABS and event.code == ecodes.ABS_MT_SLOT:
                frame_slot = event.value
                self.emit(event)
                continue

            if event.type == ecodes.EV_ABS and event.code == ecodes.ABS_MT_TRACKING_ID:
                if event.value < 0 and before[frame_slot]:
                    self.emit(event)
                elif event.value >= 0 and after[frame_slot]:
                    self.emit(event)
                continue

            if event.type == ecodes.EV_ABS and event.code in (
                ecodes.ABS_MT_POSITION_X,
                ecodes.ABS_MT_POSITION_Y,
            ):
                if before[frame_slot] or after[frame_slot]:
                    value = event.value
                    if event.code == ecodes.ABS_MT_POSITION_Y:
                        value = max(value, self.minimum_y)
                    self.output.write(event.type, event.code, value)
                continue

            if event.type == ecodes.EV_ABS and event.code in (ecodes.ABS_X, ecodes.ABS_Y):
                if has_contact:
                    value = event.value
                    if event.code == ecodes.ABS_Y:
                        value = max(value, self.minimum_y)
                    self.output.write(event.type, event.code, value)
                continue

            if event.type == ecodes.EV_KEY and event.code in (
                ecodes.BTN_TOUCH,
                *TOOL_KEYS.values(),
            ):
                continue

            if event.type == ecodes.EV_KEY and event.code == ecodes.BTN_LEFT:
                if event.value:
                    self.forwarded_click = has_contact
                    if self.forwarded_click:
                        self.emit(event)
                elif self.forwarded_click:
                    self.emit(event)
                    self.forwarded_click = False
                continue

            self.emit(event)

        desired_keys = {ecodes.BTN_TOUCH: accepted_count > 0}
        desired_keys.update((key, False) for key in TOOL_KEYS.values())
        if accepted_count in TOOL_KEYS:
            desired_keys[TOOL_KEYS[accepted_count]] = True

        for key, pressed in desired_keys.items():
            if self.reported_keys[key] != pressed:
                self.output.write(ecodes.EV_KEY, key, int(pressed))
                self.reported_keys[key] = pressed

        for slot_index in lifted_slots:
            self.slots[slot_index]["accepted"] = False
        self.output.syn()

    def run(self):
        frame = []
        for event in self.device.read_loop():
            if event.type == ecodes.EV_SYN and event.code == ecodes.SYN_REPORT:
                self.process_frame(frame)
                frame.clear()
            elif event.type == ecodes.EV_SYN and event.code == ecodes.SYN_DROPPED:
                logging.error("Input events were dropped; restarting the filter")
                raise RuntimeError("SYN_DROPPED")
            else:
                frame.append(event)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--device", required=True)
    parser.add_argument("--top-dead-zone-mm", type=float, required=True)
    args = parser.parse_args()

    logging.basicConfig(level=logging.INFO, format="%(levelname)s: %(message)s")
    device = None
    output = None

    try:
        while device is None:
            try:
                device = InputDevice(args.device)
            except OSError:
                time.sleep(1)

        if ecodes.ABS_MT_POSITION_Y not in device.capabilities().get(ecodes.EV_ABS, []):
            raise RuntimeError(f"{device.name} does not expose multitouch coordinates")

        y_info = device.absinfo(ecodes.ABS_MT_POSITION_Y)
        if y_info.resolution <= 0:
            raise RuntimeError("Touchpad does not report coordinate resolution")

        minimum_y = round(args.top_dead_zone_mm * y_info.resolution)
        if minimum_y <= 0 or minimum_y >= y_info.max - y_info.min:
            raise ValueError("Top dead zone must be smaller than the touchpad height")

        device_name = device.name
        output = UInput(
            events=device.capabilities(absinfo=True),
            name=f"{device_name} (top-edge filter)",
            vendor=device.info.vendor,
            product=device.info.product,
            version=device.info.version,
            bustype=device.info.bustype,
            phys=f"{device.phys}-top-edge-filter",
            input_props=device.input_props(),
        )
        device.grab()
        logging.info(
            "Filtering %s: ignoring starts in the top %.1f mm (%d coordinate units)",
            device_name,
            args.top_dead_zone_mm,
            minimum_y,
        )
        TouchpadFilter(device, output, minimum_y).run()
    finally:
        if device is not None:
            try:
                device.ungrab()
            except OSError:
                pass
            device.close()
        if output is not None:
            output.close()


if __name__ == "__main__":
    main()
