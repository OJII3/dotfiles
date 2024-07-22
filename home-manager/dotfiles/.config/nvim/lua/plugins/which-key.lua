return {
	"folke/which-key.nvim",
	config = function()
		local wk = require("which-key")

		wk.setup({
			triggers_blacklist = {
				i = { "j", "k", "<Shift-,>" },
				v = { "j", "k" },
			},
		})

		wk.register({
			{
				mode = { "i" },
				{ "<C-x><C-]>", desc = "tags" },
				{ "<C-x><C-d>", desc = "definitions or macros" },
				{ "<C-x><C-f>", desc = "file names" },
				{ "<C-x><C-i>", desc = "keywords in the current and included files" },
				{ "<C-x><C-k>", desc = "keywords in dictionary" },
				{ "<C-x><C-l>", desc = "Whole lines" },
				{ "<C-x><C-n>", desc = "keywords in the current file" },
				{ "<C-x><C-o>", desc = "omni completion" },
				{ "<C-x><C-s>", desc = "Spelling suggestions" },
				{ "<C-x><C-t>", desc = "keywords in thesaurus" },
				{ "<C-x><C-u>", desc = "User defined completion" },
				{ "<C-x><C-v>", desc = "Vim command-line" },
				{ "<C-x><C-z>", desc = "stop completion" },
			},
		})
	end,
	event = "BufWinEnter",
}
