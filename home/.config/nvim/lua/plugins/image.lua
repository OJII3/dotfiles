return {
	"3rd/image.nvim",
	enabled = os.getenv("TERM") == "xterm-kitty" or os.getenv("TERM") == "xterm-ghostty",
	dependencies = {
		{ "MunifTanjim/nui.nvim" },
	},
	lazy = false,
	opts = {
		integrations = {
			markdown = {
				enabled = false,
			},
			typst = {
				enabled = false,
			},
			html = {
				enabled = false,
			},
			css = {
				enabled = false,
			},
		},
	},
}
