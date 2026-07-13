# 2026-07-09-tree-sitter-manager-design

## Overview

Nix + lazy.nvim 環境で `nvim-treesitter/nvim-treesitter` を `romus204/tree-sitter-manager.nvim` に置き換える。
現行の `ensure_installed` 設計は維持し、パッケージ依存と plugin spec を最小差分で移行する。

## Goals

- アーカイブされた `nvim-treesitter` への依存を減らす
- 現在の parser 一覧と自動インストール挙動を維持する
- Nix 側の `tree-sitter` CLI / build tools との共存を明確にする
- 追加機能の大幅拡張は避け、既存運用に近い最小移行にする

## Non-Goals

- `textobjects` や `tree_docs` など、既存で未使用と見なした高度機能の再実装
- parser 管理を Nix 側へ全面移行すること
- lazy.nvim 以外の plugin manager への対応

## Current state

- 対象 Neovim: `0.12.2`
- 設定場所: `modules/home/neovim/nvim/lua/plugins/treesitter.lua`
- Nix 側ツール: `modules/home/neovim/default.nix` で `tree-sitter`, `gcc`, `cmake` 等を提供
- lazy.nvim は `modules/home/neovim/nvim/lua/plugin.lua` で bootstrap されている
- 現在の設定は `auto_install = true` と parser 一覧、`highlight`、`indent`、`incremental_selection`、`textobjects` を含む

## Proposed change

`treesitter.lua` を `romus204/tree-sitter-manager.nvim` に書き換える。

移行後の `setup()` には以下を含める:

- `ensure_installed = { ... }` に現在の parser 一覧をそのまま移す
- `auto_install = true`
- `highlight = true`
- `highlight` の言語ホワイトリストや `nohighlight` は現状不要

## Removals

- `nvim-treesitter/nvim-treesitter` plugin spec
- `build = ":TSUpdate"`
- `indent`, `incremental_selection`, `textobjects` 関連設定
- コメントアウト済みの `nvim-treesitter-textobjects`, `nvim-tree-docs`

## Nix side

- `modules/home/neovim/default.nix` の `extraPackages` にある `tree-sitter` は維持する
  - `tree-sitter-manager.nvim` は tree-sitter CLI を前提にするため
- `gcc`, `cmake`, `cargo` 等の compiler 類は現行のまま維持する

## Risks / trade-offs

- `tree-sitter-manager.nvim` は Neovim `0.12+` 必須。現環境は `0.12.2` のため問題なし
- `indent` / `incremental_selection` / `textobjects` は未使用前提で削除する
  - 現環境でこれらを積極的に使っている操作は確認されていない
  - 将来必要になった場合は別プラグインや nvim 内蔵機能で再導入を検討する
- parser の更新フローが `nvim-treesitter` と異なるため、既存の `:TSUpdate` 意図と混同しない説明が必要

## Verification

- Neovim 起動時に `romus204/tree-sitter-manager.nvim` が読み込まれること
- 既存言語の parser が `ensure_installed` 指定通りインストール/参照されること
- `indent` / `incremental_selection` / `textobjects` の削除は影響範囲が Treesitter 設定内のみであること
- `nvim-ts-autotag` など既存 plugin が壊れないこと
- `tree-sitter` CLI が Nix 経由で path に入ること
- syntax highlight が主要言語で期待通り動くこと

## Follow-up

- 万一 `indent` / `incremental_selection` / `textobjects` が必要になった場合の再導入方針を別途決める
- 将来的に parser の永続化/同期方法を整理する
