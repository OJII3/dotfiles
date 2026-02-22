return {
	"3rd/image.nvim",
	enabled = os.getenv("TERM") == "xterm-kitty" or os.getenv("TERM") == "xterm-ghostty",
	dependencies = {
		{ "MunifTanjim/nui.nvim" },
	},
	opts = {
		processor = "magick_cli",
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
	lazy = false,
}
