# claude / codex の package 供給元を llm-agents-nix に切替 (2026-06-18)

## 目的

`claude code` と `codex cli` のパッケージ供給元を、独立した `claude-code-nix` / `codex-cli-nix` input から、コミュニティ統合 flake である `llm-agents-nix` へ統一する。`pi` はすでに同 input を使っているため、3 ツールが同じ供給元に揃う。

## 背景

現状、claude と codex のパッケージは専用の個人 flake(`sadjow/claude-code-nix`, `sadjow/codex-cli-nix`)から取得している。一方 `pi` は `numtide/llm-agents.nix` 経由で取得しており、供給元が 3 系統に分散している。

`llm-agents-nix` は daily auto-update で最新 upstream を追従しており、`claude-code` / `codex` / `pi` を同等の粒度でパッケージ化している。供給元を揃えることで、レビューと更新運用を一箇所に集約できる。

## 設計

`flake.nix` から `claude-code-nix` と `codex-cli-nix` の 2 input を削除し、既存 `llm-agents-nix` input から claude / codex パッケージを取得する。`modules/home/ai/claude/` と `modules/home/ai/codex/` の package 参照部分のみ書き換える。`programs.claude-code`(home-manager 製)を介した settings.json / hooks / CLAUDE.md / abbr / shim や、codex の `home.activation.codexConfigGenerate` を含む周辺 overlay は無変更で残す。

`agy` / `opencode` / `pi` / `superpowers` / `skills.nix` には触らない。

ロックファイル更新(`nix flake update`)は本 PR の対象外。レビュアーが新供給元のコミットハッシュを確認できるよう、ロック更新は別 PR で行う。

## 変更対象

### `flake.nix`

`inputs` から次の 2 行を削除する:

```diff
-    claude-code-nix.url = "github:sadjow/claude-code-nix";
-    codex-cli-nix.url = "github:sadjow/codex-cli-nix";
```

`llm-agents-nix.url` はすでに存在するため変更しない。

### `modules/home/ai/claude/default.nix`

`programs.claude-code.package` の指定を以下のように変更する:

```diff
-      package = inputs.claude-code-nix.packages.${pkgs.stdenv.hostPlatform.system}.default;
+      package = inputs.llm-agents-nix.packages.${pkgs.stdenv.hostPlatform.system}.claude-code;
```

`programs.jq.enable` / `programs.claude-code.enable` / `home.file."."` 群(`settings.json`, `CLAUDE.md`, hooks, abbr, shim)は無変更。

### `modules/home/ai/codex/default.nix`

`home.packages` の指定を以下のように変更する:

```diff
-      inputs.codex-cli-nix.packages.${pkgs.stdenv.hostPlatform.system}.default
+      inputs.llm-agents-nix.packages.${pkgs.stdenv.hostPlatform.system}.codex
```

`home.file."."` 群(`AGENTS.md`)と `home.activation.codexConfigGenerate`(`config.toml` 生成スクリプト)は無変更。

### 無変更

- `modules/home/ai/options.nix`
- `modules/home/ai/default.nix`(集約条件式)
- `modules/home/ai/superpowers.nix`
- `modules/home/ai/skills.nix`
- `modules/home/ai/agy/`
- `modules/home/ai/opencode/`
- `modules/home/ai/pi/`

## データフロー

flake 評価時に `inputs.llm-agents-nix.packages.${system}` が `claude-code` / `codex` / `pi` の 3 属性を提供する。`dot.home.ai.claude.enable` または `dot.home.ai.codex.enable` が真のとき、各モジュールが同 input の対応属性を `home.packages` へ追加する。

claude 側は `programs.claude-code`(home-manager 製)経由で `claude` バイナリが提供され、既存の `home.file."."` 群(`settings.json` / `CLAUDE.md` / hooks / abbr / shim)がそのまま適用される。codex 側は `home.activation.codexConfigGenerate` が trusted config を生成する。

## エラーハンドリング

- `nix flake check` と `nix eval` で `llm-agents-nix.packages.${system}.claude-code` / `.codex` の存在を評価時に検証する。
- 該当属性名が存在しないバージョンにロックが更新されると `error: attribute 'claude-code' missing` 等で即座に検知できる(評価時 fail)。
- ロック更新は本 PR の対象外のため、CI 上は `nix flake update` を本ブランチで実行しない。

## テスト

1. `nix flake check` が通ること(formatter チェックを含む)。
2. claude / codex を有効化しているホスト(`feiciao` 等)に対して `home-manager build` を実行し、評価と build が成功すること。
3. 生成された `home.file` の中身(`~/.claude/settings.json`, `~/.claude/CLAUDE.md`, `~/.claude/hooks/*`, `~/.codex/AGENTS.md`, `~/.codex/config.toml`)が `git diff` 上で差分ゼロであること。
4. 起動後、`claude --version` / `codex --version` がそれぞれ最新バージョンを返すこと(手動確認)。
5. `claude` 実行時に SessionStart hook が走ること、codex 実行時に trusted な workspace として扱われることを確認(手動確認)。

## 段階的な作業ステップ

1. 作業ブランチ `feat/llm-agents-overlay` を main から作成。
2. `flake.nix` の `inputs` から `claude-code-nix` / `codex-cli-nix` の 2 行を削除。
3. `modules/home/ai/claude/default.nix` の package 参照を `llm-agents-nix.packages.${system}.claude-code` に置換。
4. `modules/home/ai/codex/default.nix` の package 参照を `llm-agents-nix.packages.${system}.codex` に置換。
5. `nix flake check` でフォーマット崩れと評価が通ることを確認。
6. claude / codex を有効化しているホストの `home-manager build` を実行し、生成差分ゼロと build 成功を確認。
7. 1 つのコミットにまとめてプッシュし PR を作成。
8. 後続で別 PR にて `nix flake update` を実施(`llm-agents-nix` の新リビジョンと他 flake の更新を分離)。
