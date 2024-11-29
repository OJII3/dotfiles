return {
	enabled = true,
	"github/Copilot.vim",
	config = function()
		vim.g.copilot_filetypes = {
			markdown = true,
			yaml = true,
			toml = true,
			gitcommit = true,
			text = true,
		}
	end,
	event = "BufRead",
}
