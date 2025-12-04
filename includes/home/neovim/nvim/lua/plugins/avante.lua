return {
	"yetone/avante.nvim",
	event = "VeryLazy",
	lazy = false,
	version = false, -- set this if you want to always pull the latest change
	opts = {
		provider = "copilot",
		-- provider = "gemini",
		-- auto_suggestions_provider = "copilot",
		providers = {
			copilot = {
				model = "claude-sonnet-4.5",
			},
			gemini = {
				model = "gemini-2.0-flash",
				temperature = 0,
				max_tokens = 4096,
			},
			claude = {
				model = "claude-sonnet-4-20250514",
			},
			morph = {
				model = "auto",
			},
		},
		cursor_applying_provider = nil,
		behaviour = {
			auto_apply_diff_after_generation = true,
			auto_suggestions = false,
			enable_cursor_planning_mode = true,
			enable_token_counting = true,
			enable_fastapply = true,
			minimize_diff = true,
			support_paste_from_clipboard = true,
		},
		acp_providers = {
			["gemini-cli"] = {
				command = "bunx @google/gemini-cli",
				args = { "--experimental-acp" },
			},
		},
		file_selector = {
			provider = "telescope",
			provider_opts = {},
		},
		web_search_engine = {
			provider = "google", -- Programmable Search Engine
		},
		mappings = {
			ask = "<Space>aa",
			edit = "<Space>ae",
			refresh = "<Space>ar",
			focus = "<Space>af",
			toggle = {
				default = "<Space>at",
				debug = "<Space>ad",
				hint = "<Space>ah",
				suggestion = "<Space>as",
				repomap = "<Space>aR",
			},
		},
		windows = {
			ask = {
				floating = false,
			},
		},
		---- The below configurations are for the mcphub.nvim plugin
		system_prompt = function()
			local hub = require("mcphub").get_hub_instance()
			if not hub then
				return
			end
			local additional_localization = "\
      If there is .cursor directory in the current working directory, examin before thinking. \
      日本語での質問に回答するときは、日本語を用い、明い女性口調で話すこと。 "
			return hub:get_active_servers_prompt() .. additional_localization
		end,
		custom_tools = function()
			return {
				require("mcphub.extensions.avante").mcp_tool(),
			}
		end,
		disabled_tools = {
			"list_files",
			"search_files",
			"read_file",
			"create_file",
			"rename_file",
			"delete_file",
			"create_dir",
			"rename_dir",
			"delete_dir",
			"bash",
		},
	},
	-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
	build = "make",
	-- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
	dependencies = {
		"stevearc/dressing.nvim",
		-- "nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		--- The below dependencies are optional,
		"hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
		"nvim-telescope/telescope.nvim", -- for file_selector provider telescope
		"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
		"stevearc/dressing.nvim", -- for input provider dressing
		"zbirenbaum/copilot.lua", -- for providers='copilot'
		{
			-- Make sure to set this up properly if you have lazy=true
			"MeanderingProgrammer/render-markdown.nvim",
			opts = {
				file_types = { "Avante" },
			},
			ft = { "Avante" },
		},
	},
}
