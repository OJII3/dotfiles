-- vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
--   pattern = { "*.ts", "*.tsx", "*.js", "*.jsx", "*.md", "*.json", "*.lua" },
--   command = "set shiftwidth=2",
-- })

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
	pattern = { "*.c", "*.h", "*.cpp", "*.hpp", "*.py" },
	command = "set shiftwidth=4",
})

vim.api.nvim_create_autocmd({ "TermOpen" }, {
	pattern = "*",
	command = "startinsert",
})

-- when pwd is ~/src/github.com/OJII3/procon (case insensitive), run :Copilot disable
vim.api.nvim_create_autocmd({ "BufEnter" }, {
	pattern = "*",
	callback = function()
		if string.match(vim.fn.getcwd(), "github.com/OJII3/procon", 1) then
			vim.cmd("Copilot disable")
		end
	end,
})

-- Hyprlang LSP
vim.filetype.add({
	pattern = { [".*/hypr.*/.*%.conf"] = "hyprlang" },
})
