return {
	"vhyrro/luarocks.nvim",
	priority = 1000,
	build = function()
		require("luarocks-nvim").setup({
			rocks = { "magick" },
		})
	end,
}
