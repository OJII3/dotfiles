return {
	{ "nvim-treesitter/nvim-tree-docs" },
	{ "nvim-treesitter/nvim-treesitter-textobjects" },
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				auto_install = true,
				sync_install = false,
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
				ignore_install = {},
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
				modules = {},
				textobjects = {
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							-- You can use the capture groups defined in textobjects.scm
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							-- You can optionally set descriptions to the mappings (used in the desc parameter of
							-- nvim_buf_set_keymap) which plugins like which-key display
							["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
							-- You can also use captures from other query groups like `locals.scm`
							["as"] = { query = "@local.scope", query_group = "locals", desc = "Select language scope" },
						},
						include_surrounding_whitespace = true,
					},
				},
			})

			vim.filetype.add({
				extension = {
					mdx = "markdown",
				},
			})
			-- vim.treesitter.language.register("mdx", "markdown")
		end,
		event = "BufEnter",
	},
}
