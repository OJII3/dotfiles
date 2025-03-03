return {
	{
		"folke/tokyonight.nvim",
		lazy = false,
		config = function()
			require("tokyonight").setup({
				hide_inactive_statusline = true,
				-- on_highlights = function(highlights, colors)
				-- 	highlights.LspInlayHint = {
				-- 		fg = "#435346",
				-- 	}
				-- 	highlights.Normal = {
				-- 		bg = "NONE",
				-- 	}
				-- end,
			})
			vim.cmd("colorscheme tokyonight-night")
		end,
	},
	-- { "ayu-theme/ayu-vim", lazy = true },
	-- { "cocopon/iceberg.vim", lazy = true },
}
