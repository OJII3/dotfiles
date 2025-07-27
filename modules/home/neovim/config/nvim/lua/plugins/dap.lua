return {
	{
		"rcarriga/nvim-dap-ui",
		-- dependencies = {
		-- 	"mfussenegger/nvim-dap",
		-- 	"nvim-neotest/nvim-nio",
		-- 	"theHamsta/nvim-dap-virtual-text",
		-- },
		config = function()
			local dap, dapui = require("dap"), require("dapui")

			dap.adapters = {
				lldb = {
					type = "server",
					port = "${port}",
					executable = {
						command = "lldb",
						args = { "--port", "${port}" },
					},
				},
			}
			dap.configurations = {
				cpp = {},
			}

			require("dap.ext.vscode")._load_json()

			dap.listeners.after.event_initialized["dapui_config"] = dapui.open
			dap.listeners.before.event_terminated["dapui_config"] = dapui.close
			dap.listeners.before.event_exited["dapui_config"] = dapui.close

			dapui.setup()
			require("nvim-dap-virtual-text").setup({})
		end,
		keys = {
			{ "<F5>", "<cmd>lua require('dap').continue()<CR>", desc = "Continue" },
			{ "<F10>", "<cmd>lua require('dap').step_over()<CR>", desc = "Step Over" },
			{ "<F11>", "<cmd>lua require('dap').step_into()<CR>", desc = "Step Into" },
			{ "<F12>", "<cmd>lua require('dap').step_out()<CR>", desc = "Step Out" },
			{ "<Leader>db", "<cmd>lua require('dap').toggle_breakpoint()<CR>", desc = "Toggle Breakpoint" },
			{
				"<Leader>dB",
				"<cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
				desc = "Set Conditional Breakpoint",
			},
			{ "<F7>", "<cmd>lua require('dapui').toggle()<CR>", desc = "Toggle DAP UI" },
			{ "<Leader>dr", "<cmd>lua require('dap').repl.open()<CR>", desc = "Open REPL" },
			{ "<Leader>dl", "<cmd>lua require('dap').run_last()<CR>", desc = "Run Last Debug Session" },
		},
	},
	{ "mfussenegger/nvim-dap", lazy = true },
	{ "theHamsta/nvim-dap-virtual-text", lazy = true },
	{ "nvim-neotest/nvim-nio", lazy = true },
}
