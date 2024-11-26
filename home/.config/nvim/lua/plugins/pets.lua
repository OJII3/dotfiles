return {
	"giusgad/pets.nvim",
	enabled = (function()
		return os.getenv("TERM") == "xterm-kitty"
	end)(),
	dependencies = {
		{ "MunifTanjim/nui.nvim" },
		{ "giusgad/hologram.nvim" },
	},
	opts = true,
	event = "VeryLazy",
}
