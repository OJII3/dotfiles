#!/bin/sh

# Usage: notify.sh <message> [duration_in_seconds]
# Sends desktop notifications using terminal-notifier on macOS or notify-send on Linux
# Title is automatically set to repository and branch name
# Duration defaults to 10 seconds if not specified

if [ $# -lt 1 ]; then
    echo "Usage: $0 <message> [duration_in_seconds]" >&2
    exit 1
fi

NOTIFICATION_TITLE="$1"
DURATION="${2:-10}"  # Default to 10 seconds
DURATION_MS=$((DURATION * 1000))  # Convert to milliseconds for notify-send

# Get repository information
get_repo_info() {
    # Check if current directory is a git repository
    if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        # Get repository name from git remote
        REMOTE_URL=$(git remote get-url origin 2>/dev/null)

        if [ -n "$REMOTE_URL" ]; then
            # Extract repo name from URL (supports both HTTPS and SSH formats)
            REPO_NAME=$(echo "$REMOTE_URL" | sed -E 's#.*/([^/]+?)(\.git)?$#\1#')
        fi

        # Fallback to directory name if no git remote
        if [ -z "$REPO_NAME" ]; then
            REPO_NAME=$(basename "$PWD")
        fi

        # Get current branch name
        BRANCH_NAME=$(git branch --show-current 2>/dev/null)

        if [ -n "$BRANCH_NAME" ]; then
            echo "$REPO_NAME ($BRANCH_NAME)"
        else
            echo "$REPO_NAME"
        fi
    else
        # Not a git repository, use directory name
        basename "$PWD"
    fi
}

REPO_INFO=$(get_repo_info)

# Detect OS
OS=$(uname -s)

case "$OS" in
    Darwin)
        # macOS
        if command -v terminal-notifier >/dev/null 2>&1; then
            terminal-notifier -title "$NOTIFICATION_TITLE" -message "$REPO_INFO" -timeout "$DURATION"
        else
            echo "Error: terminal-notifier not found" >&2
            exit 1
        fi
        # Trigger confetti effect in Raycast
        open -g raycast://confetti
        ;;
    Linux)
        # Linux
        if command -v notify-send >/dev/null 2>&1; then
            ICON_PATH="$HOME/src/github.com/ojii3/dotfiles/assets/images/cipher_icon.png"
            notify-send -t "$DURATION_MS" "$NOTIFICATION_TITLE" "$REPO_INFO" --hint=string:image-path:"$ICON_PATH"
        else
            echo "Error: notify-send not found" >&2
            exit 1
        fi
        # Trigger confetti if available
        command -v confetti >/dev/null 2>&1 && confetti
        ;;
    *)
        echo "Error: Unsupported OS: $OS" >&2
        exit 1
        ;;
esac


