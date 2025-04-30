require("base")
require("autocmd")
-- if secrets exists, load it
local ok, secrets = pcall(require, "secrets")
if ok then
	require("secrets")
end
require("plugin")
require("lsp")
require("keymappings")
