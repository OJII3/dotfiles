# OpenCode Only Superpowers Design

## Goal

Expose the pinned `obra/superpowers` integration only to OpenCode. Claude,
Codex, Antigravity, and Pi must not receive its skills, hooks, extensions, or
bootstrap files.

## Current Flow

`modules/home/ai/skills.nix` expands every directory under the superpowers
input into the Claude, Codex, and Pi skill directories. Separately,
`modules/home/ai/superpowers.nix` installs integration files for Claude,
OpenCode, Antigravity, and Pi. Claude also invokes a SessionStart hook from
its generated settings.

## Design

Keep `superpowers.nix` as the integration module, but make it OpenCode-only.
It will create only `.config/opencode/plugins/superpowers.js` when
`dot.home.ai.opencode.enable` is true. The flake input and pin remain
unchanged because the OpenCode plugin still comes from that source.

Remove the superpowers expansion from `skills.nix`, so the generic skill
distribution continues to serve local and other remote skills without
including superpowers. Remove Claude's superpowers SessionStart hook and Pi's
bootstrap file because neither has a remaining consumer. Remove the
Antigravity extension link as part of the same isolation boundary.

Update the skills README to describe superpowers as an OpenCode-only plugin.

## Verification

Evaluate representative Home Manager configurations and inspect their
`home.file` attributes. An OpenCode-enabled host must contain the OpenCode
plugin and none of the Claude, Codex, Antigravity, or Pi superpowers paths. A
host with OpenCode disabled must contain no superpowers paths. Validate the
remaining Claude settings JSON and run `nix flake check`.

## Scope

No new enable option is needed: the existing OpenCode enable flag is the
intended switch. No changes are needed to the flake input, lock file, or AI
tool package definitions.
