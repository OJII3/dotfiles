return {
	{ "numToStr/Comment.nvim", event = "BufRead" },
	{ "folke/ts-comments.nvim", event = "BufRead", opts = {
		lang = {
			typst = { "// " },
		},
	} },
}
