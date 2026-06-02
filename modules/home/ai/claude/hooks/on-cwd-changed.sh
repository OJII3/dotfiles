#!/usr/bin/env bash
set -euo pipefail

command -v direnv &>/dev/null || exit 0

direnv allow 2>/dev/null || true
direnv export bash >>"${CLAUDE_ENV_FILE:-/dev/null}" 2>/dev/null || true
