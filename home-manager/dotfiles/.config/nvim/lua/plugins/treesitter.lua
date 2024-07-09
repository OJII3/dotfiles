return {
	"nvim-treesitter/nvim-treesitter",
	build = function()
		require("nvim-treesitter.install").update({ with_sync = true })
	end,
	config = function()
		local ts = require("nvim-treesitter.configs")
		ts.setup({
			ensure_installed = {
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
			highlight = {
				enable = true,
				disable = { "latex" },
				additional_vim_regex_highlighting = { "letex", "markdown" },
			},
			indent = {
				enable = true,
			},
			tree_docs = {
				enable = true,
			},
			-- rainbow = {
			-- 	enable = true,
			-- 	extended_mode = true,
			-- 	max_file_lines = 1000,
			-- },
		})

		vim.filetype.add({
			extension = {
				mdx = "markdown",
			},
		})
		vim.treesitter.language.register("mdx", "markdown")
	end,
	event = "BufReadPre",
}
