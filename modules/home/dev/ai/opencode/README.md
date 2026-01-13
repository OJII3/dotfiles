# OpenCode (home-manager) module

This module configures OpenCode via `programs.opencode` from home-manager.

Goals
- Keep global instructions in `AGENTS.md` (`programs.opencode.rules`).
- Provide a `/plan` custom command (`programs.opencode.commands.plan`).
- Set default `programs.opencode.settings` (permissions, MCP, plugins).

Upstream options used
- `programs.opencode.enable`
- `programs.opencode.settings`
- `programs.opencode.rules`
- `programs.opencode.commands`

Notes
- MCP `context7` uses `{env:CONTEXT7_API_KEY}` in headers.
