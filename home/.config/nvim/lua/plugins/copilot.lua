return {
	enabled = true,
	"zbirenbaum/copilot.lua",
	opts = {
		filetypes = {
			yaml = true,
			markdown = true,
			help = true,
			gitcommit = true,
			gitrebase = true,
			hgcommit = true,
			svn = true,
			cvs = true,
			["."] = true,
		},
		suggestion = {
			auto_trigger = true,
			hide_during_completion = false,
			keymap = {
				accept = "<C-l>",
				accept_word = false,
				accept_line = false,
				next = "<M-]>",
				prev = "<M-[>",
				dismiss = "<C-]>",
			},
		},
	},
	event = "InsertEnter",
}
