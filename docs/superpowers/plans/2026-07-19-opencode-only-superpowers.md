# OpenCode Only Superpowers Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Restrict the pinned superpowers integration to OpenCode while preserving unrelated AI skills.

**Architecture:** Keep `superpowers.nix` as a small integration module gated by `dot.home.ai.opencode.enable`. Remove superpowers from the generic skill linker and delete the Claude, Antigravity, and Pi bootstrap paths. Verify the resulting Home Manager file map by evaluating representative hosts.

**Tech Stack:** Nix, Home Manager, JSON, `nix eval`, `nix build`, `nix flake check`.

---

### Task 1: Remove non-OpenCode distribution

**Files:**
- Modify: `modules/home/ai/skills.nix:8-12,121-129`
- Modify: `modules/home/ai/superpowers.nix:1-51`
- Modify: `modules/home/ai/claude/settings.json:42-55`
- Delete: `modules/home/ai/pi/APPEND_SYSTEM.md`

- [ ] **Step 1: Remove superpowers from generic skills**

Delete `superpowersSkills` and change `allSkills` to `localSkills ++ remoteSkills`. Keep the existing local and remote skill definitions and the Claude/Codex/Pi directory mapping unchanged.

- [ ] **Step 2: Keep only the OpenCode plugin glue**

Replace `superpowers.nix` with a module whose `config` is gated by `cfg.opencode.enable` and contains only:

```nix
{
  inputs,
  config,
  lib,
  ...
}:
let
  cfg = config.dot.home.ai;
  src = inputs.superpowers;
in
{
  config = lib.mkIf cfg.opencode.enable {
    home.file.".config/opencode/plugins/superpowers.js".source =
      src + "/.opencode/plugins/superpowers.js";
  };
}
```

- [ ] **Step 3: Remove Claude's obsolete hook**

Delete only the `hooks.SessionStart` JSON member. Preserve `CwdChanged`, `FileChanged`, and all other Claude settings. The `hooks` object must continue to contain the two remaining hook arrays.

- [ ] **Step 4: Delete Pi's obsolete bootstrap file**

Remove `modules/home/ai/pi/APPEND_SYSTEM.md`; no Nix expression should reference it after the `superpowers.nix` change.

- [ ] **Step 5: Check static references**

Run:

```bash
rg -n "superpowersSkills|claude/superpowers|gemini/extensions/superpowers|APPEND_SYSTEM|SessionStart" modules/home/ai
```

Expected: no superpowers distribution references remain except the OpenCode plugin source and documentation references that describe the behavior.

- [ ] **Step 6: Commit the implementation changes**

```bash
git add modules/home/ai/skills.nix modules/home/ai/superpowers.nix modules/home/ai/claude/settings.json modules/home/ai/pi/APPEND_SYSTEM.md
git commit -m "fix: restrict superpowers to OpenCode"
```

### Task 2: Update documentation

**Files:**
- Modify: `modules/home/ai/skills/README.md:16-21,28`

- [ ] **Step 1: Document the OpenCode-only boundary**

Replace the existing superpowers section with wording that states the flake input is used only for the automatically discovered OpenCode plugin, and that Claude, Codex, Antigravity, and Pi do not receive its skills or bootstrap integrations.

- [ ] **Step 2: Update the source note**

Keep the upstream source and version information, but remove the claim that the repository distributes a bootstrap hook to all harnesses.

- [ ] **Step 3: Commit the documentation change**

```bash
git add modules/home/ai/skills/README.md
git commit -m "docs: describe OpenCode-only superpowers"
```

### Task 3: Verify Home Manager evaluation

**Files:**
- Test: Home Manager `home.file` attributes from `.#homeConfigurations`
- Test: `modules/home/ai/claude/settings.json`

- [ ] **Step 1: Validate Claude JSON**

```bash
jq empty modules/home/ai/claude/settings.json
```

Expected: exit status 0.

- [ ] **Step 2: Evaluate an OpenCode-enabled host**

```bash
nix eval --json '.#homeConfigurations."ojii3@Aglaea".config.home.file' --apply 'files: {
  opencodePlugin = builtins.hasAttr ".config/opencode/plugins/superpowers.js" files;
  claudeTree = builtins.hasAttr ".claude/superpowers" files;
  claudeSkill = builtins.hasAttr ".claude/skills/using-superpowers" files;
  codexSkill = builtins.hasAttr ".codex/skills/using-superpowers" files;
  geminiExtension = builtins.hasAttr ".gemini/extensions/superpowers" files;
  piBootstrap = builtins.hasAttr ".pi/agent/APPEND_SYSTEM.md" files;
}'
```

Expected JSON: `{"claudeSkill":false,"claudeTree":false,"codexSkill":false,"geminiExtension":false,"opencodePlugin":true,"piBootstrap":false}`; key order may differ.

- [ ] **Step 3: Evaluate an OpenCode-disabled host**

```bash
nix eval --json '.#homeConfigurations."ojii3@Bronya".config.home.file' --apply 'files: builtins.filter (name: builtins.match ".*superpowers.*" name != null) (builtins.attrNames files)'
```

Expected: `[]`.

- [ ] **Step 4: Build the representative activation package**

```bash
nix build '.#homeConfigurations."ojii3@Aglaea".activationPackage' --no-link
```

Expected: successful build.

- [ ] **Step 5: Run repository checks**

```bash
nix flake check
```

Expected: all checks pass.

- [ ] **Step 6: Review final changes**

```bash
git status --short
```

Expected: only the design, implementation, and documentation commits are present on the feature branch, with no whitespace errors or uncommitted changes.
