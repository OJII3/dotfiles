return {
	"vim-skk/skkeleton",
	dependencies = { "vim-denops/denops.vim", lazy = false },
	init = function()
		vim.cmd([[
      function! s:skkeleton_init() abort
        call skkeleton#config({
          \ 'globalDictionaries': [
            \ '/usr/share/skk/SKK-JISYO.L',
            \ '/usr/share/skk/SKK-JISYO.fullname',
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
		{ "<C-j>", "<Plug>(skkeleton-enable)", mode = "i" },
		{ "<C-l>", "<Plug>(skkeleton-disable)", mode = "i" },
	},
	-- event = "InsertEnter",
	lazy = false,
}
