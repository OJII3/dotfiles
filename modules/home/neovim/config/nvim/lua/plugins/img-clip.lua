return {
	"HakonHarnes/img-clip.nvim",
	event = "VeryLazy",
	opts = {
		default = {
			embed_image_as_base64 = false,
			prompt_for_file_name = false,
			drag_and_drop = {
				insert_mode = true,
			},
			file_path = function()
				return os.getenv("HOME") .. "/Pictures/"
			end,
		},
		-- optional settings
		windows = {
			ask = {
				floating = false,
			},
		},
	},
}
