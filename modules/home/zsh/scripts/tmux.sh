#!/bin/sh
# t: tmuxを起動（gitリポジトリ内ならリポジトリ名をセッション名に）
x() {
  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    repo_name=$(basename "$(git rev-parse --show-toplevel)")
    tmux new-session -A -s "$repo_name"
  else
    tmux
  fi
}
