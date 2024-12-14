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
	},
	event = "InsertEnter",
}

