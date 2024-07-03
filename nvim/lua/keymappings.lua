-- builtin
vim.keymap.set("i", "jk", "<ESC>", { noremap = true, silent = true })
-- vim.keymap.set("i", "", "<ESC>", { noremap = true, silent = true }) -- while using skkeleton
vim.keymap.set("n", "j", "gj", { noremap = true, silent = true })
vim.keymap.set("n", "k", "gk", { noremap = true, silent = true })
vim.keymap.set("v", "j", "gj", { noremap = true, silent = true })
vim.keymap.set("v", "k", "gk", { noremap = true, silent = true })
vim.keymap.set("t", "<ESC>", "<C-\\><C-n>", { noremap = true, silent = true })
vim.keymap.set("t", "<C-[>", "<C-\\><C-n>", { noremap = true, silent = true })

vim.keymap.set("n", "<C-b>h", "<cmd>BufferPrevious<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-b><C-h>", "<cmd>BufferPrevious<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-b>l", "<cmd>BufferNext<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-b><C-l>", "<cmd>BufferNext<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-b>d", "<cmd>BufferDelete<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-b><C-d>", "<cmd>BufferClose<CR>", { noremap = true, silent = true })

-- plugins --

-- telescope
vim.keymap.set("n", "<Space>g", "<cmd>Telescope git_files<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<Space>f", "<cmd>Telescope find_files<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<Space>o", "<cmd>Telescope oldfiles<cr>", { noremap = true, silent = true })
vim.keymap.set("n", "<Space>r", "<cmd>Telescope live_grep<CR>", { noremap = true, silent = true })

-- lightspeed
vim.keymap.set("n", "s", "<Plug>Lightspeed_s", { noremap = true, silent = true })
-- vim.keymap.del("n", "s")
-- coc
-- vim.keymap.set("i", "<C-Space>", "coc#refresh()", { expr = true, silent = true })    -- trigger completion
-- vim.keymap.set("n", "<Leader>rn", "<Plug>(coc-rename)", { silent = true })           -- rename
-- vim.keymap.set("n", "<Leader>fm", "<Plug>(coc-format)", { silent = true })           -- format
-- vim.keymap.set("n", "<Leader>c", "<Plug>(coc-codeaction-cursor)", { silent = true }) -- code action
-- vim.keymap.set("n", "<Leader>a", "<Plug>(coc-codeaction)", { silent = true })        -- code action
-- vim.keymap.set("n", "gr", "<Plug>(coc-references)", { silent = true })               -- references
-- vim.keymap.set("n", "gd", "<Plug>(coc-definition)", { silent = true })               -- go to definition
-- vim.keymap.set("n", "gy", "<Plug>(coc-type-definition)", { silent = true })          -- go to type definition
-- vim.keymap.set("n", "[g", "<Plug>(coc-diagnostic-prev)", { silent = true })          -- go to previous diagnostic
-- vim.keymap.set("n", "]g", "<Plug>(coc-diagnostic-next)", { silent = true })          -- go to next diagnostic

-- builtin lsp
vim.keymap.set("n", "<Leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", { silent = true }) -- rename
vim.keymap.set("n", "<Leader>fm", "<cmd>lua vim.lsp.buf.format()<CR>", { silent = true }) -- format
vim.keymap.set("n", "<Leader>a", "<cmd>lua vim.lsp.buf.code_action()<CR>", { silent = true }) -- code
vim.keymap.set("n", "ge", "<cmd>lua vim.lcwsp.diagnostic.open_float()<CR>", { silent = true }) -- code
vim.keymap.set("n", "gr", "<cmd>lua require('telescope.builtin').lsp_references()<CR>", { silent = true }) -- references
vim.keymap.set("n", "gd", "<cmd>lua require('telescope.builtin').lsp_definitions()<CR>", { silent = true }) -- go to definition
vim.keymap.set("n", "gy", "<cmd>lua require('telescope.builtin').lsp_type_definitions()<CR>", { silent = true }) -- go to type definition
vim.keymap.set("n", "[g", "<cmd>lua vim.diagnostic.goto_prev()<CR>", { silent = true }) -- go to previous diagnostic
vim.keymap.set("n", "]g", "<cmd>lua vim.diagnostic.goto_next()<CR>", { silent = true }) -- go to next diagnostic
vim.keymap.set("n", "<Leader>q", "<cmd>lua vim.diagnostic.set_loclist()<CR>", { silent = true }) -- set loclist
