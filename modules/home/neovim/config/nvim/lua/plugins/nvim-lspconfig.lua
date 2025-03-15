return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{ "folke/neoconf.nvim" },
		{
			"williamboman/mason.nvim",
			enabled = not vim.fn.executable("home-manager"),
			event = "VeryLazy",
		},
		{
			"williamboman/mason-lspconfig.nvim",
			enabled = not vim.fn.executable("home-manager"),
			cmd = { "LspInstall", "LspUninstall" },
		},
		{
			"b0o/schemastore.nvim",
			ft = { "json", "yaml", "toml" },
		},
		{ "dmmulroy/ts-error-translator", ft = "typescript" },
	},
	opts = {
		format = { timeout_ms = 50000 },
	},
	config = function()
		local lspconfig = require("lspconfig")
		-- vim.lsp.handlers["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
		-- 	require("ts-error-translator").translate_diagnostics(err, result, ctx, config)
		-- 	vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx, config)
		-- end

		local server_list = {
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
			"lua_ls",
			"mdx_analyzer",
			"pyright",
			"pyright",
			"stylelint_lsp",
			-- "tailwindcss",
			"taplo",
			"texlab",
			"ts_ls",
			"matlab_ls",
			"tinymist",
			"vimls",
			"yamlls",
		}

		-------------------------------------
		-- Handlers for each language server
		-------------------------------------
		local setup_handler = function(server_name)
			if server_name == "efm" then
				return
			end

			local default_opts = {
				capabilities = require("blink.cmp").get_lsp_capabilities(),
			}
			local opts = {}
			if server_name == "denols" then
				-- INFO: Neccessary for avoiding conflict with other js severs
				opts = {
					root_dir = lspconfig.util.root_pattern("deno.json"),
					init_options = {
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
					},
				}
			elseif server_name == "clangd" then
				opts = {
					cmd = { "clangd", "--background-index", "--enable-config" },
				}
			elseif server_name == "eslint" then
				opts.on_attach = function(client, bufnr)
					vim.api.nvim_create_autocmd("BufWritePre", {
						buffer = bufnr,
						command = "EslintFixAll",
					})
				end
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
			lspconfig[server_name].setup(vim.tbl_deep_extend("force", default_opts, opts))
		end

		-----------------------------------------------
		-- Setup ls with mason or without mason
		-----------------------------------------------
		if vim.fn.executable("home-manager") then
			for _, server in ipairs(server_list) do
				setup_handler(server)
			end
		else
			require("mason").setup({
				PATH = "append",
			})
			local mason_lsp = require("mason-lspconfig")
			mason_lsp.setup({
				ensure_installed = server_list,
			})
			mason_lsp.setup_handlers({ setup_handler })
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
	end,
	event = "BufReadPre",
}
