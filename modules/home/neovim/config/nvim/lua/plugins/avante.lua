return {
	"yetone/avante.nvim",
	event = "VeryLazy",
	lazy = false,
	version = false, -- set this if you want to always pull the latest change
	opts = {
		provider = "copilot",
		auto_suggestions_provider = "copilot",
		copilot = {
			model = "claude-3.7-sonnet",
		},
		cursor_applying_provider = nil,
		behaviour = {
			auto_apply_diff_after_generation = false,
			auto_suggestions = false,
			enable_cursor_planning_mode = true,
			enable_token_counting = true,
			minimize_diff = true,
			support_paste_from_clipboard = true,
		},
		file_selector = {
			provider = "telescope",
			provider_opts = {},
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
			return hub:get_active_servers_prompt()
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
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		--- The below dependencies are optional,
		"hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
		"nvim-telescope/telescope.nvim", -- for file_selector provider telescope
		"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
		"zbirenbaum/copilot.lua", -- for providers='copilot'
		{
			-- support for image pasting
			"HakonHarnes/img-clip.nvim",
			event = "VeryLazy",
			opts = {
				-- recommended settings
				default = {
					embed_image_as_base64 = false,
					prompt_for_file_name = false,
					drag_and_drop = {
						insert_mode = true,
					},
					-- required for Windows users
					use_absolute_path = true,
				},
			},
		},
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
