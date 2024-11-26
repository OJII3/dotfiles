return {
	"hrsh7th/nvim-cmp",
	dependencies = {
		{ "hrsh7th/cmp-nvim-lsp" },
		-- { "hrsh7th/cmp-vsnip" },
		{ "saadparwaiz1/cmp_luasnip" },
		{ "hrsh7th/cmp-buffer" },
		{ "hrsh7th/cmp-path" },
		{ "hrsh7th/cmp-cmdline" },
		{ "hrsh7th/cmp-nvim-lsp-signature-help" },
		{ "onsails/lspkind-nvim" },
	},
	config = function()
		local cmp = require("cmp")
		local lspkind = require("lspkind")

		cmp.setup({
			snippet = {
				-- REQUIRED - you must specify a snippet engine
				expand = function(args)
					-- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
					require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
					-- require('snippy').expand_snippet(args.body) -- For `snippy` users.
					-- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
				end,
			},
			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
				border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
			},
			experimental = {
				ghost_text = true,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete(),
				["<C-e>"] = cmp.mapping.abort(),
				["<CR>"] = cmp.mapping.confirm({ select = false, behavior = cmp.ConfirmBehavior.Replace }),
				["<C-i>"] = cmp.mapping.confirm({ select = true }),
				["<C-n>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "s" }),
				["<C-p>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "s" }),
				["<Tab>"] = cmp.config.disable,
			}),
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				-- { name = 'vsnip' }, -- For vsnip users.
				{ name = "luasnip" }, -- For luasnip users.
				-- { name = 'ultisnips' }, -- For ultisnips users.
				-- { name = 'snippy' }, -- For snippy users.
			}, {
				{ name = "buffer" },
			}),
			formatting = {
				fields = { "abbr", "kind", "menu" },
				expandable_indicator = true,
				format = lspkind.cmp_format({ with_text = true, maxwidth = 50 }),
			},
		})

		-- Set configuration for specific filetype.
		-- cmp.setup.filetype("gitcommit", {
		-- 	sources = cmp.config.sources({
		-- 		{ name = "git" }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
		-- 	}, {
		-- 		{ name = "buffer" },
		-- 	}),
		-- })

		-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
		cmp.setup.cmdline({ "/", "?" }, {
			mapping = cmp.mapping.preset.cmdline(),
			sources = {
				{ name = "buffer" },
			},
		})

		-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
		cmp.setup.cmdline(":", {
			mapping = cmp.mapping.preset.cmdline(),
			sources = cmp.config.sources({
				{ name = "path" },
			}, {
				{ name = "cmdline" },
			}),
		})

		-- Set up lspconfig. -->>> lsp.lua
		-- local capabilities = require('cmp_nvim_lsp').default_capabilities()
		-- -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
		-- require('lspconfig')['stylua'].setup {
		--   capabilities = capabilities
		-- }
	end,
	event = "InsertEnter",
}
