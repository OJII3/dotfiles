#!/bin/sh

# notify.sh
# Claude Code フック用通知スクリプト
# Usage: notify.sh <event_type>
#   event_type: permission_prompt | idle_prompt | stop
#
# リモート転送ポート: 19999 (固定)

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

# イベントタイプごとのメッセージと表示時間
get_message() {
    case "$1" in
        permission_prompt)
            echo "ちょっと～、許可くれない？早く終わらせたいんだからさ～"
            ;;
        idle_prompt)
            echo "ねぇ、暇なんだけど～。何かやることないの？"
            ;;
        stop)
            echo "ふあ～、終わったよ！疾風より速いでしょ？"
            ;;
        *)
            echo "$1"
            ;;
    esac
}

get_duration() {
    case "$1" in
        permission_prompt|idle_prompt)
            echo "5"
            ;;
        stop)
            echo "10"
            ;;
        *)
            echo "10"
            ;;
    esac
}

# リポジトリ情報を取得
get_repo_info() {
    if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        REMOTE_URL=$(git remote get-url origin 2>/dev/null)

        if [ -n "$REMOTE_URL" ]; then
            REPO_NAME=$(echo "$REMOTE_URL" | sed -E 's#.*/([^/]+)(\.git)?$#\1#')
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

# リモート（SSH元）に通知を送信
# SSH RemoteForward が設定されていれば転送、なければ単に失敗（エラーは無視）
send_to_remote() {
    PORT="19999"
    echo "${1}|${2}|${3}" | nc -w 1 localhost "$PORT" 2>/dev/null &
}

# メイン処理
main() {
    if [ $# -lt 1 ]; then
        echo "Usage: $0 <event_type>" >&2
        echo "  event_type: permission_prompt | idle_prompt | stop" >&2
        exit 1
    fi

    EVENT_TYPE="$1"
    MESSAGE=$(get_message "$EVENT_TYPE")
    DURATION=$(get_duration "$EVENT_TYPE")
    REPO_INFO=$(get_repo_info)

    # リモートに通知を送信（非同期）
    send_to_remote "$MESSAGE" "$REPO_INFO" "$DURATION"

    # OS を検出して適切なスクリプトを実行
    OS=$(uname -s)

    case "$OS" in
        Darwin)
            "$SCRIPT_DIR/notify-darwin.sh" "$MESSAGE" "$REPO_INFO" "$DURATION"
            ;;
        Linux)
            "$SCRIPT_DIR/notify-linux.sh" "$MESSAGE" "$REPO_INFO" "$DURATION"
            ;;
        *)
            echo "Error: Unsupported OS: $OS" >&2
            exit 1
            ;;
    esac

    # Claude Code のデフォルト通知を抑制
    echo '{"suppressDefaultNotification": true}'
}

main "$@"
