# AI Skills

Home Manager で `.claude/skills` と `.codex/skills` に配置する Agent Skills。

このディレクトリ配下の `*/SKILL.md` は `modules/home/ai/skills.nix` により自動検出されます。外部のリポジトリから取り込んだ skill は、出典確認と作者へのリスペクトのため、この README に参照元を残します。

## Sources

| Skill | Source | Notes |
|-------|--------|-------|
| `missing-tools` | [ryoppippi/dotfiles `agents/skills/missing-tools/SKILL.md`](https://github.com/ryoppippi/dotfiles/blob/31766ba36dd3d7cbad1deb7270f5ba0e56e06e2d/agents/skills/missing-tools/SKILL.md) | Missing CLI tools をグローバルインストールせず、`direnv` / comma / `nix run` / `nix shell` で解決する workflow。 |
