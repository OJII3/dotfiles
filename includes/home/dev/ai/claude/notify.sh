#!/bin/sh

# Usage: notify.sh <title> <message>
# Sends desktop notifications using terminal-notifier on macOS or notify-send on Linux

if [ $# -lt 2 ]; then
    echo "Usage: $0 <title> <message>" >&2
    exit 1
fi

TITLE="$1"
MESSAGE="$2"

# Detect OS
OS=$(uname -s)

case "$OS" in
    Darwin)
        # macOS
        if command -v terminal-notifier >/dev/null 2>&1; then
            terminal-notifier -title "$TITLE" -message "$MESSAGE"
        else
            echo "Error: terminal-notifier not found" >&2
            exit 1
        fi
        ;;
    Linux)
        # Linux
        if command -v notify-send >/dev/null 2>&1; then
            notify-send "$TITLE" "$MESSAGE"
        else
            echo "Error: notify-send not found" >&2
            exit 1
        fi
        ;;
    *)
        echo "Error: Unsupported OS: $OS" >&2
        exit 1
        ;;
esac


