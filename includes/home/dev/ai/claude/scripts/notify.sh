#!/bin/sh

# Usage: notify.sh <title> <message>
# Sends desktop notifications using terminal-notifier on macOS or notify-send on Linux

if [ $# -lt 2 ]; then
    echo "Usage: $0 <title> <message>" >&2
    exit 1
fi

TITLE="$1"
MESSAGE="$2"

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
            terminal-notifier -title "$TITLE" -message "$MESSAGE" -subtitle "$REPO_INFO 📦"
        else
            echo "Error: terminal-notifier not found" >&2
            exit 1
        fi
        # Trigger confetti effect in Raycast
        open raycast://confetti
        ;;
    Linux)
        # Linux
        if command -v notify-send >/dev/null 2>&1; then
            notify-send "$TITLE" "$MESSAGE\n$REPO_INFO 📦"
        else
            echo "Error: notify-send not found" >&2
            exit 1
        fi
        confetti
        ;;
    *)
        echo "Error: Unsupported OS: $OS" >&2
        exit 1
        ;;
esac


