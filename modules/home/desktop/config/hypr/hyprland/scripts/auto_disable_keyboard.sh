#!/bin/sh

HOST_KB_ENABLED=true

# Function to check if an external keyboard is connected
check_external_keyboard() {
    hyprctl devices | grep -i "eucalyn-mint60"
}

# Function to disable the host keyboard

enable_keyboard() {
  HOST_KB_ENABLED=true
  hyprctl keyword '$LAPTOP_KB_ENABLED' "true" -r &&
    notify-send -u low "Host Keyboard Enabled"
}

disable_keyboard() {
  HOST_KB_ENABLED=false
  hyprctl keyword '$LAPTOP_KB_ENABLED' "false" -r &&
    notify-send -u low "Host Keyboard Disabled"
}

# Infinite loop to check for external keyboard and disable host keyboard


while true; do
  if $HOST_KB_ENABLED && check_external_keyboard; then
    disable_keyboard
  elif ! $HOST_KB_ENABLED && ! check_external_keyboard; then
    enable_keyboard
  fi
  sleep 2
done

