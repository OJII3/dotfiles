return {
	"mattn/efm-langserver",
	dependencies = {
		{ "neovim/nvim-lspconfig" }, -- for backward compatibility
		{ "creativenull/efmls-configs-nvim" },
	},
	config = function()
		local nvim_lsp_efm = vim.lsp.efm
		-- local languages = require("efmls-configs.defaults").languages()

		local stylua = require("efmls-configs.formatters.stylua")
		local clang_format = require("efmls-configs.formatters.clang_format")
		local clang_tidy = require("efmls-configs.linters.clang_tidy")
		local latexindent = require("efmls-configs.formatters.latexindent")
		local cmake_lint = require("efmls-configs.linters.cmake_lint")
		local shellcheck = require("efmls-configs.linters.shellcheck")
		local rustfmt = require("efmls-configs.formatters.rustfmt")
		local yamllint = require("efmls-configs.linters.yamllint")
		-- local cspell = require("efmls-configs.linters.cspell")
		-- local stylelint_linter = require("efmls-configs.linters.stylelint")
		-- local stylelint_formatter = require("efmls-configs.formatters.stylelint")
		-- TypeScript, JavaScript
		-- local eslint_linter = require("efmls-configs.linters.eslint")
		-- local eslint_formatter = require("efmls-configs.formatters.eslint")
		local prettier = require("efmls-configs.formatters.prettier")
		local biome = require("efmls-configs.formatters.biome")
		-- Python
		local ruff = require("efmls-configs.formatters.ruff")
		local black = require("efmls-configs.formatters.black")
		local isort = require("efmls-configs.formatters.isort")
		local autopep8 = require("efmls-configs.formatters.autopep8")
		local flake8 = require("efmls-configs.linters.flake8")
		local mypy = require("efmls-configs.linters.mypy")
		-- Haskell
		local formulu = require("efmls-configs.formatters.fourmolu")
		local textlint = require("efmls-configs.linters.textlint")
		local typstyle = require("efmls-configs.formatters.typstyle")

		-- customized or manually installed linters/formatters
		local biome = {
			formatCommand = string.format(
				"%s %s",
				"node_modules/.bin/biome",
				"check --write --unsafe --stdin-file-path '${INPUT}'"
			),
			formatStdin = true,
			roootMarkers = { "biome.json", "biome.jsonc" },
		}
		local cmake_format = {
			formatCommand = "cmake-format ${--line-width:100} -",
			formatStdin = true,
			rootMarkers = { "CMakeLists.txt" },
		}

		vim.lsp.config("efm", {
			init_options = {
				documentFormatting = true,
				codeAction = true,
			},
			filetypes = {
				"astro",
				"c",
				"cmake",
				"cpp",
				"cs",
				"css",
				"haskell",
				"javascript",
				"javascriptreact",
				"json",
				"latex",
				"lua",
				"markdown",
				"python",
				"rust",
				"sh",
				"typescript",
				"typescriptreact",
				"typst",
				"yaml",
				"nix",
			},
			settings = {
				rootMarkers = { ".git/" },
				languages = {
					astro = { prettier },
					c = { clang_format, clang_tidy },
					cmake = { cmake_lint, cmake_format },
					cpp = { clang_format, clang_tidy },
					css = { prettier },
					haskell = { formulu },
					javascript = { prettier },
					javascriptreact = { prettier },
					json = { prettier },
					latex = { latexindent },
					lua = { stylua },
					markdown = { textlint },
					python = { ruff, black, isort, autopep8, flake8, mypy },
					rust = { rustfmt },
					sh = { shellcheck },
					typescript = { prettier },
					typescriptreact = { prettier, biome },
					typst = { typstyle },
					yaml = { yamllint },
					nix = {
						{
							lintCommand = "nix-linter",
							lintFormats = {
								"%f:%l:%c: %m",
							},
							lintStdin = true,
							formatCommand = "nixpkgs-fmt",
							formatStdin = true,
						},
					},
				},
			},
		})

		-- Format on save
		local lsp_fmt_group = vim.api.nvim_create_augroup("LspFormattingGroup", {})
		vim.api.nvim_create_autocmd("BufWritePost", {
			group = lsp_fmt_group,
			callback = function(ev)
				local efm = vim.lsp.get_clients({ name = "efm", bufnr = ev.buf })

				if vim.tbl_isempty(efm) then
					return
				end

				if vim.bo.filetype == "typst" or vim.bo.filetype == "tex" then
					vim.cmd("silent! %s/。/. /g | silent! %s/、/, /g")
				end

				vim.lsp.buf.format({ name = "efm" })
			end,
		})
	end,
	event = "BufReadPre",
}
