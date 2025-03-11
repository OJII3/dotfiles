#!/bin/sh

STATUS_FILE="$XDG_RUNTIME_DIR/touchpad.status"
HYPRLAND_VAR='$LAPTOP_TOUCHPAD_ENABLED'

enable_keyboard() {
    printf "true" >"$STATUS_FILE"
    hyprctl keyword $HYPRLAND_VAR "true" -r &&
      notify-send -u normal "Touchpad Enabled"
}

disable_keyboard() {
    printf "false" >"$STATUS_FILE"
    hyprctl keyword $HYPRLAND_VAR "false" -r &&
      notify-send -u normal "Touchpad Disabled"
}

if ! [ -f "$STATUS_FILE" ]; then
  printf "true" >"$STATUS_FILE"
  disable_keyboard
else
  if [ "$(cat "$STATUS_FILE")" = "true" ]; then
    disable_keyboard
  elif [ "$(cat "$STATUS_FILE")" = "false" ]; then
    enable_keyboard
  fi
fi

exit 0

