require("base")
require("autocmd")
-- if secrets exists, load it
local ok, secrets = pcall(require, "secrets")
if ok then
	require("secrets")
end
require("plugin")
vim.api.nvim_create_user_command("LspHealth", "checkhealth vim.lsp", { desc = "LSP Check Health" })
require("keymappings")
