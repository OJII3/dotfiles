vim.api.nvim_create_user_command("LspHealth", "checkhealth vim.lsp", { desc = "LSP Check Healh" })

-- 設定したlspを保存する配列
local lsp_names = {
	"astro",
	"bashls",
	"biome",
	"clangd",
	"cmake",
	"cssls",
	"cssls",
	"denols",
	"docker_compose_language_service",
	"dockerls",
	"efm",
	"eslint",
	"graphql",
	"html",
	"hyprls",
	"jsonls",
	"jsonls",
	"lemminx",
	"nil_ls",
	"nixd",
	"lua_ls",
	"mdx_analyzer",
	"ty",
	-- "rust_analyzer", -- rustaceanvim will handle this
	"roslyn_ls",
	"stylelint_lsp",
	"tailwindcss",
	"taplo",
	"terraformls",
	"texlab",
	"ts_ls",
	"matlab_ls",
	"tinymist",
	"vimls",
	"yamlls",
}

for _, server_name in ipairs(lsp_names) do
	local opts = {
		capabilities = require("blink.cmp").get_lsp_capabilities(),
	}
	if server_name == "biome" then
		opts.root_dir = function(_, callback)
			local root_dir = vim.fs.root(0, { "biome.json", "biome.jsonc" })
			if vim.fs.root then
				callback(root_dir)
			end
		end
	elseif server_name == "denols" then
		opts.root_dir = function(_, callback)
			local root_dir = vim.fs.root(0, {
				"deno.json",
				"deno.jsonc",
				"deps.ts",
			})
			if root_dir then
				callback(root_dir)
			end
		end
		opts.init_options = {
			lint = true,
			unstable = true,
			suggest = {
				imports = {
					hosts = {
						["https://deno.land"] = true,
						["https://cdn.nest.land"] = true,
						["https://crux.land"] = true,
					},
				},
			},
		}
	elseif server_name == "clangd" then
		opts.cmd = { "clangd", "--offset-encoding=utf-16", "--enable-config" }
	-- elseif server_name == "eslint" then
	-- 	opts.on_attach = function(client, bufnr)
	-- 		vim.api.nvim_create_autocmd("BufWritePre", {
	-- 			buffer = bufnr,
	-- 			command = "EslintFixAll",
	-- 		})
	-- 	end
	elseif server_name == "stylelint_lsp" then
		opts.filetypes = { "css", "scss", "less", "sass" } -- exclude javascript and typescript
	elseif server_name == "jsonls" then
		opts.settings = {
			json = {
				schemas = require("schemastore").json.schemas(),
				validate = true,
			},
		}
	elseif server_name == "yamlls" then
		opts.settings = {
			yaml = {
				schemaStore = {
					enable = true,
					url = "",
				},
				schemas = require("schemastore").yaml.schemas(),
			},
		}
	elseif server_name == "tinymist" then
		opts.settings = {
			exportPdf = "onType",
			formatterMode = "typstyle",
		}
	end
	vim.lsp.config(server_name, opts)
	vim.lsp.enable(server_name)
end

local function on_list(options)
	vim.fn.setqflist({}, " ", options)
	vim.api.nvim_command("cfirst")
end

vim.lsp.buf.definition({ on_list = on_list })
vim.lsp.buf.references(nil, { on_list = on_list })
vim.diagnostic.config({
	virtual_text = {
		source = true,
	},
})

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if not client then
			return
		end
		client.server_capabilities.semanticTokensProvider = nil
		if client.server_capabilities.inlayHintProvider then
			vim.lsp.inlay_hint.enable(true)
		end
	end,
})
