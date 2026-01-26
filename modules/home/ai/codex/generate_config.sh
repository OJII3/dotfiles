#!/usr/bin/env bash
set -euo pipefail

SEED_TOML="$1"
CONFIG_PATH="$2"

mkdir -p "$(dirname "$CONFIG_PATH")"

# Start with seed config
cat "$SEED_TOML" > "$CONFIG_PATH"

# Add trusted repositories from ghq
ghq_root="$(ghq root 2>/dev/null || echo "")"
if [[ -n "$ghq_root" && -d "$ghq_root" ]]; then
  echo "" >> "$CONFIG_PATH"
  echo "# Auto-generated trusted repositories from ghq" >> "$CONFIG_PATH"

  find "$ghq_root" -mindepth 3 -maxdepth 3 -type d 2>/dev/null | sort | while read -r repo_path; do
    # Escape path for TOML (double quotes need escaping)
    escaped_path="${repo_path//\\/\\\\}"
    escaped_path="${escaped_path//\"/\\\"}"
    echo "[projects.\"$escaped_path\"]" >> "$CONFIG_PATH"
    echo 'trust_level = "trusted"' >> "$CONFIG_PATH"
    echo "" >> "$CONFIG_PATH"
  done
fi

chmod 600 "$CONFIG_PATH"
