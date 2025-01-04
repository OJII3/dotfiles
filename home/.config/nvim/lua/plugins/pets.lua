return {
	"giusgad/pets.nvim",
	enabled = os.getenv("TERM") == "xterm-kitty" or os.getenv("TERM") == "xterm-ghostty",
	dependencies = {
		{ "MunifTanjim/nui.nvim" },
		{ "giusgad/hologram.nvim" },
	},
	opts = true,
	event = "VeryLazy",
}
