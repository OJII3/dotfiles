return {
	enabled = (function()
		return os.getenv("TERM") == "xterm-kitty"
	end)(),
	"giusgad/pets.nvim",
	dependencies = {
		{ "MunifTanjim/nui.nvim" },
		{ "giusgad/hologram.nvim" },
	},
	opts = true,
	event = "VeryLazy",
}
