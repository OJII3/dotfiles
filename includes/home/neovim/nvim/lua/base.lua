vim.cmd("autocmd!")
local opt = vim.opt
opt.autoindent = true
opt.backup = false
opt.breakindent = true
opt.clipboard = "unnamedplus"
opt.cmdheight = 2
opt.cursorline = true
opt.encoding = "utf-8"
opt.expandtab = true
opt.fileencoding = "utf-8"
opt.fileformat = "unix"
opt.helplang = "en"
opt.hidden = true
opt.hlsearch = true
opt.ignorecase = true
opt.inccommand = "split"
opt.laststatus = 3
opt.list = true
opt.mouse = "a"
opt.number = true
opt.pumblend = 7
opt.relativenumber = false
opt.ruler = true
opt.scrolloff = 10
opt.shell = os.getenv("SHELL")
opt.shiftwidth = 2
opt.showcmd = true
opt.showmode = false
opt.showtabline = 2
opt.signcolumn = "yes"
opt.smartindent = true
opt.smarttab = true
opt.swapfile = true
opt.tabstop = 2
opt.termguicolors = true
opt.title = true
opt.updatetime = 300
opt.wrap = false
opt.wrap = true
vim.g.mapleader = " "
vim.scriptencoding = "utf-8"

if vim.g.neovide then
	opt.guifont = "HackGen:h12"
end
