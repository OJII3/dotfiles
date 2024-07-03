return {
	"lervag/vimtex",
	config = function()
		vim.g.vimtex_view_method = "general"
		vim.g.vimtex_view_general_viewer = "xdg-open"
		vim.g.vimtex_view_general_options = "@pdf"
		vim.g.vimtex_format_enabled = 1
		vim.g.vimtex_fold_types = "<sections>"
		vim.g.vimtex_compiler_method = "latexmk"
		vim.cmd([[
let g:vimtex_compiler_latexmk = {
            \ 'background' : 0,
            \ 'build_dir' : '',
            \ 'continuous' : 1,
            \ 'options' : [
            \   '-pdfdvi',
            \   '-verbose',
            \   '-file-line-error',
            \   '-synctex=1',
            \   '-interaction=nonstopmode',
            \ ],
            \}
]])
	end,
	ft = { "tex" },
}
