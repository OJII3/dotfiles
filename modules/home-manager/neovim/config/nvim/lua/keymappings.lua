-- builtin
vim.keymap.set("i", "jk", "<ESC>", { noremap = true, silent = true })
-- vim.keymap.set("i", "", "<ESC>", { noremap = true, silent = true }) -- while using skkeleton
vim.keymap.set("n", "j", "gj", { noremap = true, silent = true })
vim.keymap.set("n", "k", "gk", { noremap = true, silent = true })
vim.keymap.set("v", "j", "gj", { noremap = true, silent = true })
vim.keymap.set("v", "k", "gk", { noremap = true, silent = true })
vim.keymap.set("t", "<ESC>", "<C-\\><C-n>", { noremap = true, silent = true })
vim.keymap.set("t", "<C-[>", "<C-\\><C-n>", { noremap = true, silent = true })
vim.keymap.set("n", "<M-h>", "<C-w>h", { noremap = true, silent = true })
vim.keymap.set("n", "<M-j>", "<C-w>j", { noremap = true, silent = true })
vim.keymap.set("n", "<M-k>", "<C-w>k", { noremap = true, silent = true })
vim.keymap.set("n", "<M-l>", "<C-w>l", { noremap = true, silent = true })

vim.keymap.set("n", "g<C-y>", "ggyG", { noremap = true, silent = true })

vim.keymap.set("i", "<C-e>", "<End>", { noremap = true, silent = true })
vim.keymap.set("i", "<C-a>", "<Home>", { noremap = true, silent = true })

-- builtin lsp
vim.keymap.set("n", "<Leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", { silent = true }) -- rename
vim.keymap.set("n", "<Leader>fm", "<cmd>lua vim.lsp.buf.format()<CR>", { silent = true }) -- format
-- vim.keymap.set("n", "<Leader>a", vim.lsp.buf.code_action, { silent = true }) -- code
vim.keymap.set("n", "<leader>a", require("actions-preview").code_actions, { silent = true }) -- code
vim.keymap.set("n", "<C-.>", require("actions-preview").code_actions, { silent = true }) -- code
vim.keymap.set("n", "K", vim.lsp.buf.hover, { silent = true }) -- hover
vim.keymap.set("n", "ge", vim.diagnostic.open_float, { silent = true }) -- code
vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references, { silent = true }) -- references
vim.keymap.set("n", "gd", require("telescope.builtin").lsp_definitions, { silent = true }) -- go to definition
vim.keymap.set("n", "gy", require("telescope.builtin").lsp_type_definitions, { silent = true }) -- go to type definition
vim.keymap.set("n", "[g", vim.diagnostic.goto_prev, { silent = true }) -- go to previous diagnostic
vim.keymap.set("n", "]g", vim.diagnostic.goto_next, { silent = true }) -- go to next diagnostic
vim.keymap.set("n", "gl", vim.diagnostic.setloclist, { silent = true }) -- set loclist
