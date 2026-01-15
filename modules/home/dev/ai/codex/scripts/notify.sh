#!/bin/sh

# notify.sh
# Codex 用通知スクリプト（~/.claude/scripts の notify-* を利用）
#
# Usage: notify.sh '<json>'
#   json: {"type": "...", "last-assistant-message": "..."} など

CLAUDE_SCRIPTS_DIR="${HOME}/.claude/scripts"

get_message() {
    case "$1" in
        approval-requested)
            echo "許可が必要だよ"
            ;;
        agent-turn-complete)
            echo "完了したよ"
            ;;
        *)
            echo "Codex から通知"
            ;;
    esac
}

get_duration() {
    case "$1" in
        approval-requested)
            echo "5"
            ;;
        *)
            echo "10"
            ;;
    esac
}

get_repo_info() {
    if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        REMOTE_URL=$(git remote get-url origin 2>/dev/null)

        if [ -n "$REMOTE_URL" ]; then
            REPO_NAME=$(echo "$REMOTE_URL" | sed -E 's#.*/([^/]+?)(\.git)?$#\1#')
        fi

        if [ -z "$REPO_NAME" ]; then
            REPO_NAME=$(basename "$PWD")
        fi

        BRANCH_NAME=$(git branch --show-current 2>/dev/null)

        if [ -n "$BRANCH_NAME" ]; then
            echo "$REPO_NAME ($BRANCH_NAME)"
        else
            echo "$REPO_NAME"
        fi
    else
        basename "$PWD"
    fi
}

send_to_remote() {
    PORT="19999"
    echo "${1}|${2}|${3}" | nc -w 1 localhost "$PORT" 2>/dev/null &
}

parse_payload() {
    PAYLOAD="$1"
    if [ -z "$PAYLOAD" ]; then
        EVENT_TYPE="agent-turn-complete"
        LAST_MESSAGE=""
        return 0
    fi

    eval "$(
        python3 - "$PAYLOAD" <<'PY'
import json
import shlex
import sys

payload = sys.argv[1]
event_type = "agent-turn-complete"
last_message = ""

try:
    data = json.loads(payload)
    event_type = data.get("type") or data.get("event_type") or event_type
    last_message = data.get("last-assistant-message") or data.get("last_message") or ""
except Exception:
    pass

print("EVENT_TYPE=" + shlex.quote(event_type))
print("LAST_MESSAGE=" + shlex.quote(last_message))
PY
    )"
}

main() {
    parse_payload "${1:-}"

    MESSAGE=$(get_message "$EVENT_TYPE")
    if [ -n "$LAST_MESSAGE" ]; then
        MESSAGE="$LAST_MESSAGE"
    fi
    DURATION=$(get_duration "$EVENT_TYPE")
    REPO_INFO=$(get_repo_info)

    send_to_remote "$MESSAGE" "$REPO_INFO" "$DURATION"

    OS=$(uname -s)
    case "$OS" in
        Darwin)
            if [ -x "$CLAUDE_SCRIPTS_DIR/notify-darwin.sh" ]; then
                "$CLAUDE_SCRIPTS_DIR/notify-darwin.sh" "$MESSAGE" "$REPO_INFO" "$DURATION"
            else
                echo "Error: notify-darwin.sh not found in $CLAUDE_SCRIPTS_DIR" >&2
                exit 1
            fi
            ;;
        Linux)
            if [ -x "$CLAUDE_SCRIPTS_DIR/notify-linux.sh" ]; then
                "$CLAUDE_SCRIPTS_DIR/notify-linux.sh" "$MESSAGE" "$REPO_INFO" "$DURATION"
            else
                echo "Error: notify-linux.sh not found in $CLAUDE_SCRIPTS_DIR" >&2
                exit 1
            fi
            ;;
        *)
            echo "Error: Unsupported OS: $OS" >&2
            exit 1
            ;;
    esac
}

main "$@"
