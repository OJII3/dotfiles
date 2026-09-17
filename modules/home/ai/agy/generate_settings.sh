#!/usr/bin/env bash
set -euo pipefail

SEED_JSON="$1"
CONFIG_PATH="$2"

mkdir -p "$(dirname "$CONFIG_PATH")"

ghq_repositories='[]'
if command -v ghq >/dev/null 2>&1; then
  if ghq_repositories="$(
    ghq list --full-path 2>/dev/null \
      | sort -u \
      | jq -Rsc 'split("\n") | map(select(length > 0))'
  )"; then
    :
  else
    ghq_repositories='[]'
  fi
fi

temporary_config="$(mktemp "${CONFIG_PATH}.tmp.XXXXXX")"
trap 'rm -f "$temporary_config"' EXIT

jq --argjson ghqRepositories "$ghq_repositories" '
  .trustedWorkspaces = (((.trustedWorkspaces // []) + $ghqRepositories) | unique | sort)
' "$SEED_JSON" > "$temporary_config"

chmod 600 "$temporary_config"
mv -f "$temporary_config" "$CONFIG_PATH"
