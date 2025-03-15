return {
	"akinsho/toggleterm.nvim",
	config = function()
		require("toggleterm").setup()
		local term = require("toggleterm.terminal").Terminal
		local tig = term:new({ cmd = "tig status", hidden = true, direction = "float" })
		local lazygit = term:new({ cmd = "lazygit", hidden = true, direction = "float" })
		function Tig_toggle()
			tig:toggle()
		end
		function Lazygit_toggle()
			lazygit:toggle()
		end
	end,
	keys = {
		{ "<C-\\>", "<cmd>ToggleTerm<CR>", mode = "t" },
		{ "<space>tv", "<cmd>ToggleTerm direction=vertical size=100<CR>", mode = "n" },
		{ "<space>th", "<cmd>ToggleTerm direction=horizontal size=16<CR>", mode = "n" },
		{ "<space>tf", "<cmd>ToggleTerm direction=float<CR>", mode = "n" },
		{ "<space>tt", "<cmd>lua Tig_toggle()<CR>", mode = "n" },
		{ "<space>tl", "<cmd>lua Lazygit_toggle()<CR>", mode = "n" },
	},
	event = "BufWinEnter",
}
