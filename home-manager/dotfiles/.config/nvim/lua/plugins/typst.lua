return {
	{
		"kaarmu/typst.vim",
		lazy = true,
		ft = { "typst" },
	},
	{
		"chomosuke/typst-preview.nvim",
		version = "0.1.*",
		config = true,
		build = function()
			require("typst-preview").update()
		end,
		ft = { "typst" },
	},
}
