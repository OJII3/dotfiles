return {
	"ray-x/lsp_signature.nvim",
	event = "LspAttach",
	opts = {},
	config = function()
		require("lsp_signature").setup()
	end,
}
