# tree-sitter-manager.nvim 移行 実装計画

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Neovim の Treesitter parser 管理を `nvim-treesitter/nvim-treesitter` から `romus204/tree-sitter-manager.nvim` に切り替える

**Architecture:** 現行の `ensure_installed` 一覧を維持したまま、plugin spec と設定 API を `tree-sitter-manager.nvim` に書き換える。Nix 側の `tree-sitter` CLI / compiler 類は現行のまま維持する。

**Tech Stack:** Neovim 0.12, lazy.nvim, Nix Home Manager, tree-sitter-manager.nvim

---

## File Map

- Modify: `modules/home/neovim/nvim/lua/plugins/treesitter.lua`
- Read only: `modules/home/neovim/default.nix`
- Read only: `modules/home/neovim/nvim/lua/plugin.lua`

## Task 1: 移行計画ドキュメントを追加する

- [ ] **Step 1: 計画ドキュメントを作成する**

この計画自体を `docs/superpowers/plans/2026-07-09-tree-sitter-manager.md` に保存済みです。

- [ ] **Step 2: ドキュメントだけ先にコミットする**

```bash
git add docs/superpowers/plans/2026-07-09-tree-sitter-manager.md
git commit -m "docs: add treesitter manager migration plan"
```

## Task 2: Treesitter plugin spec を置き換える

- [ ] **Step 1: `modules/home/neovim/nvim/lua/plugins/treesitter.lua` を書き換える**

```lua
return {
	{
		"romus204/tree-sitter-manager.nvim",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("tree-sitter-manager").setup({
				auto_install = true,
				ensure_installed = {
					"astro",
					"bash",
					"c",
					"cmake",
					"comment",
					"cpp",
					"css",
					"diff",
					"dockerfile",
					"git_config",
					"gitcommit",
					"gitignore",
					"go",
					"gomod",
					"graphql",
					"html",
					"java",
					"javascript",
					"jsdoc",
					"json",
					"latex",
					"lua",
					"markdown",
					"markdown_inline",
					"python",
					"regex",
					"rust",
					"toml",
					"tsx",
					"typescript",
					"typst",
					"vimdoc",
					"xml",
					"yaml",
				},
				highlight = true,
			})
		end,
	},
}
```

- [ ] **Step 2: Nix 側で `tree-sitter` CLI が依然として渡されていることを確認する**

`modules/home/neovim/default.nix` の `extraPackages` に `tree-sitter` が残っていることを確認します。変更は不要です。

- [ ] **Step 3: Neovim headless で読み込みエラーがないことを確認する**

```bash
nvim --headless +"lua print('tree-sitter-manager ok')" +qa || true
```

Expected: プラグイン読み込みで致命的なエラーが出ない

- [ ] **Step 4: lazy.nvim の設定整合を確認する**

`modules/home/neovim/nvim/lua/plugin.lua` の `spec = { { import = "plugins" } }` が従来通り `treesitter.lua` を読み込むことを確認します。変更は不要です。

- [ ] **Step 5: 変更をコミットする**

```bash
git add modules/home/neovim/nvim/lua/plugins/treesitter.lua
git commit -m "feat(neovim): migrate treesitter to tree-sitter-manager.nvim"
```
