return {
	"rcarriga/nvim-notify",
	config = function()
		vim.notify = require("notify")
	end,
	keys = {
		{
			"<leader>nt",
			function()
				vim.notify("Hello from nvim-notify!")
			end,
			desc = "Notify - Hello",
		},
	},
	event = "BufRead",
}
