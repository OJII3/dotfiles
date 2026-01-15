#!/bin/sh

# notify-darwin.sh
# macOS 用デスクトップ通知（terminal-notifier）

# Arguments: title message [duration_seconds]
TITLE="$1"
MESSAGE="$2"
DURATION="${3:-10}"

if ! command -v terminal-notifier >/dev/null 2>&1; then
    echo "Error: terminal-notifier not found" >&2
    exit 1
fi

terminal-notifier -title "$TITLE" -message "$MESSAGE" -timeout "$DURATION"

# Trigger confetti effect in Raycast
open -g raycast://confetti
