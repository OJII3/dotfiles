-- auto bootstrap lazy.nvim ======================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- setup lazy.nivm ==========================================================

-- vim.g.mapleader = ' ' -- make sure to set `mapleader` before lazy so your mappings are correct

require("lazy").setup({
	{ "folke/neoconf.nvim", cmd = "Neoconf" },
	{ "nvim-tree/nvim-web-devicons", lazy = true },
	-- colorscheme ----------------
	------------------------------
	-- { "neoclide/coc.nvim",        branch = "release" },
	-- {
	--   'nmac427/guess-indent.nvim',
	--   config = function() require('guess-indent').setup {} end,
	-- },
	-- {
	-- 	"glepnir/lspsaga.nvim",
	-- 	branch = "main",
	-- },
	-- },
	{
		"kylechui/nvim-surround",
		config = function()
			require("nvim-surround").setup()
		end,
		event = "BufRead",
	},
	{ "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" }, lazy = false },
	{
		"ggandor/lightspeed.nvim",
		event = "VeryLazy",
	},
	{
		"nvim-treesitter/nvim-treesitter",
		config = function()
			require("nvim-treesitter.install").update({ with_sync = true })
		end,
		event = "BufRead",
	},
	{
		"nvim-treesitter/nvim-tree-docs",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		event = "BufRead",
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		event = "BufRead",
	},
	-- { "ryicoh/deepl.vim", },
	-- { 'haya14busa/vim-edgemotion' },
	-- { "johngrib/vim-game-code-break", event = "VeryLazy" },
	-- { "goolord/alpha-nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },
	-- { "monaqa/dial.nvim" },
	-- {
	-- 	"mfussenegger/nvim-dap",
	-- 	dependencies = { "rcarriga/nvim-dap-ui" },
	-- 	event = "VeryLazy",
	-- },
	{
		"mxsdev/nvim-dap-vscode-js",
		event = "VeryLazy",
	},
	-- {
	-- 	"glacambre/firenvim",
	-- 	lazy = not vim.g.started_by_firenvim,
	-- 	build = function()
	-- 		vim.fn["firenvim#install"](0)
	-- 	end,
	-- },
	{ import = "plugins", lazy = true },
})
