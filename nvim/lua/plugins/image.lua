return {
	enabled = function()
		return os.getenv("TERM") == "xterm-kitty"
	end,
	"3rd/image.nvim",
	dependencies = {
		{ "luarocks.nvim" },
	},
	config = true,
}
