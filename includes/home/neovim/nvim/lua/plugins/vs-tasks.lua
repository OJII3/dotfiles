return {
	"EthanJWright/vs-tasks.nvim",
	-- dependencies = {
		-- "nvim-lua/popup.nvim",
		-- "nvim-lua/plenary.nvim",
		-- "nvim-telescope/telescope.nvim"
	-- },
	keys = {
		{
			"<C-Shift-B>",
			"<cmd>lua require('telescope').extensions.vstask.launch()<cr>",
			{
				noremap = true,
				silent = true,
				desc = "Launch VS Task",
			},
		},
	},
}
