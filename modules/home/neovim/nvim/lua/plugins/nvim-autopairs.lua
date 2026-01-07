return {
	"windwp/nvim-autopairs",
	opts = {
		map_c_w = true,
		map_c_h = true,
		check_ts = true,
		enable_check_bracket_line = true,
	},
	config = function(_, opts)
		local autopairs = require("nvim-autopairs")
		autopairs.setup(opts)
		local Rule = require("nvim-autopairs.rule")
		local conds = require("nvim-autopairs.conds")
		autopairs.add_rule(Rule("$$", "$$", "tex"))
		autopairs.add_rules({
			Rule("$", "$", { "typst" }):with_pair(conds.not_after_regex("[a-zA-Z0-9_]")),
		})
	end,
	event = "InsertEnter",
}
