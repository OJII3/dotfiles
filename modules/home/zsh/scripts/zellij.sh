#!/bin/sh
# z: zellijを起動（gitリポジトリ内ならリポジトリ名をセッション名に）
z() {
  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    repo_name=$(basename "$(git rev-parse --show-toplevel)")
    zellij attach -c "$repo_name"
  else
    zellij
  fi
}
