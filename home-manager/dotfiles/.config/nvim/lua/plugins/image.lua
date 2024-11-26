return {
	"3rd/image.nvim",
	enabled = function()
		return os.getenv("TERM") == "xterm-kitty"
	end,
	dependencies = {
		{ "MunifTanjim/nui.nvim" },
	},
  lazy = false,
}
