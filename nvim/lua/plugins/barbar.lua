return {
	"romgrk/barbar.nvim",
	opts = {
		animation = true,
		auto_hide = false,
		tabpages = true,
		icons = {
			buffer_index = false,
			buffer_number = false,
			button = " ",
			diagnostics = {
				[vim.diagnostic.severity.ERROR] = { enabled = true, icon = "" },
				[vim.diagnostic.severity.WARN] = { enabled = true, icon = "" },
				[vim.diagnostic.severity.INFO] = { enabled = false },
				[vim.diagnostic.severity.HINT] = { enabled = true },
			},
			gitsigns = {
				added = { enabled = true, icon = "" },
				changed = { enabled = true, icon = "" },
				deleted = { enabled = true, icon = "" },
			},
			filetype = {
				custom_colors = false,
				enabled = true,
			},
			preset = "default",
		},
	},
	event = "BufRead",
}
