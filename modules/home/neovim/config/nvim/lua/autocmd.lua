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
