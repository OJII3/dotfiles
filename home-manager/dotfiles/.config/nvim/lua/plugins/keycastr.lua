return {
	"4513ECHO/nvim-keycastr",
	enable = false,
	config = function()
		local keycastr = require("keycastr")
		keycastr.config.set({
			position = "SE",
			ignore_mouse = false,
			win_config = {
				border = "rounded",
				width = 50,
				height = 1,
			},
		})
	end,
	keys = {
		{ "<leader>kc", "<cmd>lua require('keycastr').enable()<CR>", mode = "n" },
		{ "<leader>kd", "<cmd>lua require('keycastr').disable()<CR>", mode = "n" },
		{ "<leader>kh", "<cmd>lua require('keycastr').hide()<CR>", mode = "n" },
		{ "<leader>ks", "<cmd>lua require('keycastr').show()<CR>", mode = "n" },
	},
  event = "VeryLazy",
}
