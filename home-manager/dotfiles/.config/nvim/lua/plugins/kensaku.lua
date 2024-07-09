return {
	"lambdalisue/kensaku-search.vim",
	dependencies = {
		{ "vim-denops/denops.vim", lazy = false },
		{ "lambdalisue/kensaku.vim" },
	},
	keys = {
		{ "<CR>", "<Plug>(kensaku-search-replace)<CR>", mode = "c" },
	},
  lazy = false,
}
