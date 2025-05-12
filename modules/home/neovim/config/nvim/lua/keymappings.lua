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

vim.keymap.set("n", "g<C-y>", "mzggyG`z", { noremap = true, silent = true })

-- Emacs-like keybindings in insert mode and command mode
vim.keymap.set("i", "<C-e>", "<C-o>$", { noremap = true, silent = true }) -- End of line
vim.keymap.set("i", "<C-a>", "<C-o>^", { noremap = true, silent = true }) -- Beginning of line
vim.keymap.set("i", "<C-f>", "<Right>", { noremap = true, silent = true }) -- Forward one character
vim.keymap.set("i", "<C-b>", "<Left>", { noremap = true, silent = true }) -- Back one character
vim.keymap.set("i", "<C-n>", "<Down>", { noremap = true, silent = true }) -- Next line
vim.keymap.set("i", "<C-p>", "<Up>", { noremap = true, silent = true }) -- Previous line
vim.keymap.set("i", "<M-f>", "<C-o>w", { noremap = true, silent = true }) -- Forward one word
vim.keymap.set("i", "<M-b>", "<C-o>b", { noremap = true, silent = true }) -- Back one word
vim.keymap.set("i", "<C-d>", "<Delete>", { noremap = true, silent = true }) -- Delete forward
vim.keymap.set("i", "<C-h>", "<BS>", { noremap = true, silent = true }) -- Delete backward

-- Command mode emacs bindings
vim.keymap.set("c", "<C-e>", "<End>", { noremap = true })
vim.keymap.set("c", "<C-a>", "<Home>", { noremap = true })
vim.keymap.set("c", "<C-f>", "<Right>", { noremap = true })
vim.keymap.set("c", "<C-b>", "<Left>", { noremap = true })
vim.keymap.set("c", "<C-d>", "<Delete>", { noremap = true })
vim.keymap.set("c", "<C-h>", "<BS>", { noremap = true })
vim.keymap.set("c", "<C-n>", "<Down>", { noremap = true })
vim.keymap.set("c", "<C-p>", "<Up>", { noremap = true })

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
vim.keymap.set("n", "[g", function()
	vim.diagnostic.jump({ count = -1, float = true })
end, { silent = true }) -- go to previous diagnostic
vim.keymap.set("n", "]g", function()
	vim.diagnostic.jump({ count = 1, float = true })
end, { silent = true }) -- go to next diagnostic
vim.keymap.set("n", "gl", vim.diagnostic.setloclist, { silent = true }) -- set loclist
