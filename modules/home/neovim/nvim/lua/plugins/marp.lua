return {
	"nwiizo/marp.nvim",
	ft = { "markdown" },
	config = function()
		require("marp").setup({
			marp_command = "marp",
			browser = nil,
			server_mode = false,
		})
	end,
	keys = {
		{ "<leader>mw", "<cmd>MarpWatch<CR>", mode = "n", ft = "markdown", desc = "Marp watch" },
		{ "<leader>mp", "<cmd>MarpPreview<CR>", mode = "n", ft = "markdown", desc = "Marp preview" },
		{ "<leader>ms", "<cmd>MarpStop<CR>", mode = "n", ft = "markdown", desc = "Marp stop" },
		{ "<leader>me", "<cmd>MarpExport<CR>", mode = "n", ft = "markdown", desc = "Marp export" },
	},
}
