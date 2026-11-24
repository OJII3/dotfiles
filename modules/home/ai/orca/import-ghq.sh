#!/usr/bin/env bash
set -euo pipefail

if [[ -n "${DRY_RUN:-}" ]]; then
  echo "orca-import-ghq: DRY_RUN set, skipping"
  exit 0
fi

deadline=$(( SECONDS + 30 ))
until orca repo list --json >/dev/null 2>&1; do
  if (( SECONDS >= deadline )); then
    echo "orca-import-ghq: Orca runtime unreachable after 30s, skipping" >&2
    exit 0
  fi
  sleep 1
done

succeeded=0
failed=0
repos=$(ghq list --full-path)
while IFS= read -r repo; do
  [[ -n "$repo" ]] || continue
  if orca repo add --path "$repo" --kind git --json >/dev/null; then
    succeeded=$(( succeeded + 1 ))
  else
    failed=$(( failed + 1 ))
    echo "orca-import-ghq: failed to add $repo" >&2
  fi
done <<< "$repos"

echo "orca-import-ghq: registered ${succeeded} repositories, ${failed} failed"
if (( failed > 0 )); then
  exit 1
fi
