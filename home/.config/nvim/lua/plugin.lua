-- auto bootstrap lazy.nvim ======================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- setup lazy.nivm ==========================================================

-- vim.g.mapleader = ' ' -- make sure to set `mapleader` before lazy so your mappings are correct

require("lazy").setup({
	rocks = {
		enabled = false,
		hererocks = false,
	},
	spec = {
		{ "folke/neoconf.nvim", cmd = "Neoconf" },
		{ "nvim-tree/nvim-web-devicons", lazy = true },
		{
			"kylechui/nvim-surround",
			config = function()
				require("nvim-surround").setup()
			end,
			event = "BufRead",
		},
		{
			"ggandor/lightspeed.nvim",
			event = "VeryLazy",
		},
		{
			"mxsdev/nvim-dap-vscode-js",
			event = "VeryLazy",
		},
		{ import = "plugins" },
	},
})
