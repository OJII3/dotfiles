# AI Skills

Home Manager で各 AI ツールのスキルディレクトリに配置する Agent Skills。

## 仕組み

`modules/home/ai/skills.nix` がスキルのリンクを管理する。

- **内蔵スキル**: このディレクトリ配下の `*/SKILL.md` を自動検出する。
- **リモートスキル**: `skills.nix` の `remoteSkills` に flake input / `fetchFromGitHub` で定義する。
- **enable 連動**: `dot.home.ai.<tool>.enable` が有効なツール (`claude` / `codex`) にのみリンクする。
- **出し分け**: 各スキル定義に `tools = [ ... ]` を付けると対象ツールを限定できる (既定は全ツール)。

外部のリポジトリから取り込んだ skill は、出典確認と作者へのリスペクトのため、この README に参照元を残す。

## superpowers

[obra/superpowers](https://github.com/obra/superpowers) は複数スキルとハーネス向け導入機構を持つプラグイン。flake input `superpowers` (`flake.lock` で pin) として取り込み、OpenCode の自動検出 plugin としてのみ公開する。

Claude、Codex、Antigravity、Pi には superpowers の skills、hook、extension、bootstrap を配布しない。

## Sources

| Skill | Source | Notes |
|-------|--------|-------|
| `missing-tools` | [ryoppippi/dotfiles `agents/skills/missing-tools/SKILL.md`](https://github.com/ryoppippi/dotfiles/blob/31766ba36dd3d7cbad1deb7270f5ba0e56e06e2d/agents/skills/missing-tools/SKILL.md) | Missing CLI tools をグローバルインストールせず、`direnv` / comma / `nix run` / `nix shell` で解決する workflow。 |
| `superpowers` | [obra/superpowers](https://github.com/obra/superpowers) (`v5.1.0`) | OpenCode plugin として読み込む TDD / debugging / planning / collaboration の workflow スキル群。flake input 経由。 |
| `stop-ai-slop-jp` | [iKora128/stop-ai-slop-jp](https://github.com/iKora128/stop-ai-slop-jp) | 日本語の文章からAI臭を取り除く Claude Skill |
