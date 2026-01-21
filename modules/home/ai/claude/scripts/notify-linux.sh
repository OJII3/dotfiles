#!/bin/sh

# notify-linux.sh
# Linux 用デスクトップ通知（notify-send）

# Arguments: title message [duration_seconds]
TITLE="$1"
MESSAGE="$2"
DURATION="${3:-10}"
DURATION_MS=$((DURATION * 1000))
ICON_PATH="$HOME/.assets/images/cipher_icon.png"

if ! command -v notify-send >/dev/null 2>&1; then
    echo "Error: notify-send not found" >&2
    exit 1
fi

notify-send -t "$DURATION_MS" "$TITLE" "$MESSAGE" --hint=string:image-path:"$ICON_PATH"

# Trigger confetti if available
command -v confetti >/dev/null 2>&1 && confetti
