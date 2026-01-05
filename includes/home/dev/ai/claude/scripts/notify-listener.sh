#!/bin/sh

# notify-listener.sh
# SSH元（ローカル）で起動し、リモートからの通知を受け取って表示する
# Usage: notify-listener.sh [port]
#
# systemd/launchd で自動起動される想定

PORT="${1:-19999}"
SCRIPT_DIR="$(dirname "$(readlink -f "$0" 2>/dev/null || realpath "$0")")"

# ログ出力（systemd/launchd 用）
log() {
    echo "[notify-listener] $1"
}

log "Starting listener on port $PORT..."

while true; do
    # netcat でリッスンし、受信したメッセージを処理
    # BSD netcat と GNU netcat の両方に対応
    MESSAGE=$(nc -l "$PORT" 2>/dev/null || nc -l -p "$PORT" 2>/dev/null)

    if [ -n "$MESSAGE" ]; then
        # メッセージ形式: "title|repo_info|duration"
        TITLE=$(echo "$MESSAGE" | cut -d'|' -f1)
        REPO_INFO=$(echo "$MESSAGE" | cut -d'|' -f2)
        DURATION=$(echo "$MESSAGE" | cut -d'|' -f3)
        DURATION="${DURATION:-10}"

        log "Received: $TITLE ($REPO_INFO)"

        # OS を検出して適切なスクリプトを実行
        OS=$(uname -s)

        case "$OS" in
            Darwin)
                if [ -x "$SCRIPT_DIR/notify-darwin.sh" ]; then
                    "$SCRIPT_DIR/notify-darwin.sh" "$TITLE" "$REPO_INFO" "$DURATION"
                elif command -v terminal-notifier >/dev/null 2>&1; then
                    terminal-notifier -title "$TITLE" -message "$REPO_INFO" -timeout "$DURATION"
                    open -g raycast://confetti 2>/dev/null
                fi
                ;;
            Linux)
                if [ -x "$SCRIPT_DIR/notify-linux.sh" ]; then
                    "$SCRIPT_DIR/notify-linux.sh" "$TITLE" "$REPO_INFO" "$DURATION"
                elif command -v notify-send >/dev/null 2>&1; then
                    notify-send -t "$((DURATION * 1000))" "$TITLE" "$REPO_INFO"
                fi
                ;;
            *)
                log "Unsupported OS: $OS"
                ;;
        esac
    fi
done
