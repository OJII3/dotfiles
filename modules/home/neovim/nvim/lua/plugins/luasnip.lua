return {
	"L3MON4D3/LuaSnip",
	lazy = true,
	dependencies = { "rafamadriz/friendly-snippets" },
	build = "make install_jsregexp",
	config = function()
		require("luasnip.loaders.from_vscode").lazy_load()
		-- luasnip
	end,
	event = "InsertEnter",
	keys = {
		{ "<C-K>", "<cmd>lua require'luasnip'.expand()<CR>", mode = "i" },
		{ "<C-Shift-l>", "<cmd>lua require'luasnip'.jump(1)<CR>", mode = { "i", "s" } },
		{ "<C-Shift-j>", "<cmd>lua require'luasnip'.jump(-1)<CR>", mode = { "i", "s" } },
	},
}
