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
				accept = "<Tab>",
			},
		},
	},
	event = "InsertEnter",
}
