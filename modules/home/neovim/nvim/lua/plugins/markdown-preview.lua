return {
	"iamcco/markdown-preview.nvim",
	cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
	build = "cd app && nix run nixpkgs#bun install",
	ft = { "markdown" },
	config = function()
		vim.g.mkdp_filetypes = { "markdown" }
	end,
	keys = {
		{ "<leader>ll", "<cmd>MarkdownPreviewToggle<CR>", mode = "n", ft = "markdown" },
	},
}
