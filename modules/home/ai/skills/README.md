# AI Skills

Home Manager で各 AI ツールのスキルディレクトリに配置する Agent Skills。

## 仕組み

`modules/home/ai/skills.nix` がスキルのリンクを管理する。

- **内蔵スキル**: このディレクトリ配下の `*/SKILL.md` を自動検出する。
- **リモートスキル**: `skills.nix` の `remoteSkills` に flake input / `fetchFromGitHub` で定義する。
- **enable 連動**: `dot.home.ai.<tool>.enable` が有効なツール (`claude` / `codex`) にのみリンクする。
- **出し分け**: 各スキル定義に `tools = [ ... ]` を付けると対象ツールを限定できる (既定は全ツール)。

外部のリポジトリから取り込んだ skill は、出典確認と作者へのリスペクトのため、この README に参照元を残す。

## Sources

| Skill | Source | Notes |
|-------|--------|-------|
| `missing-tools` | [ryoppippi/dotfiles `agents/skills/missing-tools/SKILL.md`](https://github.com/ryoppippi/dotfiles/blob/31766ba36dd3d7cbad1deb7270f5ba0e56e06e2d/agents/skills/missing-tools/SKILL.md) | Missing CLI tools をグローバルインストールせず、`direnv` / comma / `nix run` / `nix shell` で解決する workflow。 |
| `stop-ai-slop-jp` | [iKora128/stop-ai-slop-jp](https://github.com/iKora128/stop-ai-slop-jp) | 日本語の文章からAI臭を取り除く Claude Skill |
| `latex-to-typst` | [christopherkenny/skills `skills/latex-to-typst`](https://github.com/christopherkenny/skills/tree/main/skills/latex-to-typst) | LaTeX (.tex) を Typst (.typ) へ変換するリファレンス集。MIT (LICENSE 同梱)。[brycewang-stanford/Auto-Empirical-Research-Skills](https://github.com/brycewang-stanford/Auto-Empirical-Research-Skills) 経由で入手。 |
| `stack-diagram` | [caru-ini/stack-diagram `skills/stack-diagram`](https://github.com/caru-ini/stack-diagram/tree/main/skills/stack-diagram) | 技術スタックから公式ロゴ入りのアーキテクチャ図 (HTML / PNG / TSX) を生成する skill。MIT (LICENSE 同梱)、同梱フォントは SIL OFL 1.1。 |
| `security-audit` | [cloudflare/security-audit-skill `skills/security-audit`](https://github.com/cloudflare/security-audit-skill/tree/main/skills/security-audit) | ソース起点のセキュリティ監査 / ペネトレーションレビュー workflow。攻撃クラス別の companion と `findings.json` の検証スクリプトを同梱。MIT (LICENSE 同梱)。 |
| `moonbit-*`, `make-moonbit-c-bindings`, `ocaml2moonbit-migration` | [moonbitlang/skills](https://github.com/moonbitlang/skills) | MoonBit 公式の Agent Skills 集 (9 個)。`skills.sources.json` にある通り一部は上流リポジトリからの vendored copy。 |
