return {
	"lambdalisue/kensaku-search.vim",
	dependencies = {
		{ "lambdalisue/kensaku.vim" },
		{ "vim-denops/denops.vim" },
	},
	keys = {
		{ "<CR>", "<Plug>(kensaku-search-replace)<CR>", mode = "c" },
	},
	lazy = false,
}
