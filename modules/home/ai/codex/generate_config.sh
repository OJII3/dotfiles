#!/usr/bin/env bash
set -euo pipefail

SEED_TOML="$1"
CONFIG_PATH="$2"

mkdir -p "$(dirname "$CONFIG_PATH")"

# Codex stores hook approval hashes in this generated config. Keep that state
# across regeneration so Home Manager does not ask to trust unchanged hooks again.
existing_hook_state=""
if [[ -f "$CONFIG_PATH" ]]; then
  existing_hook_state="$(sed -n '/^\[hooks\.state\]$/,$p' "$CONFIG_PATH")"
fi

# Start with seed config
cat "$SEED_TOML" > "$CONFIG_PATH"

# Add trusted repositories from ghq
ghq_root="$(ghq root 2>/dev/null || echo "")"
if [[ -n "$ghq_root" && -d "$ghq_root" ]]; then
  echo "" >> "$CONFIG_PATH"
  echo "# Auto-generated trusted repositories from ghq" >> "$CONFIG_PATH"

  while read -r repo_path; do
    # Escape path for TOML (double quotes need escaping)
    escaped_path="${repo_path//\\/\\\\}"
    escaped_path="${escaped_path//\"/\\\"}"
    echo "[projects.\"$escaped_path\"]" >> "$CONFIG_PATH"
    echo 'trust_level = "trusted"' >> "$CONFIG_PATH"
    echo "" >> "$CONFIG_PATH"
  done < <(find "$ghq_root" -mindepth 3 -maxdepth 3 -type d 2>/dev/null | sort)
fi

if [[ -n "$existing_hook_state" ]]; then
  printf '\n%s\n' "$existing_hook_state" >> "$CONFIG_PATH"
fi

chmod 600 "$CONFIG_PATH"
