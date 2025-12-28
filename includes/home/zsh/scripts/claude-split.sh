#!/bin/sh
# z: zellijを起動（gitリポジトリルートならリポジトリ名をセッション名に）
z() {
  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    root=$(git rev-parse --show-toplevel)
    if [ "$PWD" = "$root" ]; then
      repo_name=$(basename "$root")
      zellij attach -c "$repo_name"
      return
    fi
  fi
  zellij
}

# x: 縦に3分割してclaudeを起動
x() {
  if [ -z "$ZELLIJ" ]; then
    echo "Zellij session required. Run 'z' first."
    return 1
  fi
  zellij run --direction right -- claude
  zellij run --direction right -- claude
  claude
}
