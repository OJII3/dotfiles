return {
	"vim-skk/skkeleton",
	dependencies = {
		{ "vim-denops/denops.vim" },
	},
	config = function()
		vim.cmd([[
      function! s:skkeleton_init() abort
        call skkeleton#config({
          \ 'globalDictionaries': [
            \ '~/.skk/SKK-JISYO.L',
            \ ],
          \ })
      endfunction
      augroup skkeleton-initialize-pre
        autocmd!
        autocmd User skkeleton-initialize-pre call s:skkeleton_init()
      augroup END
      ]])
	end,
	keys = {
		{
			"<C-j>",
			function()
				-- fcitx5 の IME が有効なままだとローマ字がそちらに取られる。
				require("ime").disable()
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Plug>(skkeleton-enable)", true, false, true), "m", false)
			end,
			mode = "i",
		},
		-- { "<l>", "<Plug>(skkeleton-disable)", mode = "i" },
	},
	lazy = false,
}
