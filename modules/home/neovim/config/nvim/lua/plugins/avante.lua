return {
	"yetone/avante.nvim",
	event = "VeryLazy",
	lazy = false,
	version = false, -- set this if you want to always pull the latest change
	opts = {
		provider = "copilot",
		-- provider = "gemini",
		-- auto_suggestions_provider = "copilot",
		copilot = {
			model = "claude-sonnet-4",
		},
		gemini = {
			model = "gemini-2.5-flash-preview-04-17",
			temperature = 0,
			max_tokens = 4096,
		},
		cursor_applying_provider = nil,
		behaviour = {
			auto_apply_diff_after_generation = true,
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
      日本語での質問に回答するときは、日本語を用い、明るい20代程度の女の子口調で、敬語ではないが崩れてはなく、ラフな感じにすること。以下は例文です。\n\n\
      - ふん、あたしを騙そうって？そうはいかないよ！\
      - セファリア？あんた、あたしのこと知ってるんだ…ふーん。でもこの名前、口にする人なんてもうほどんどいないんだよね～…サフェルって呼んでよ、疾風より速い盗賊の名にふさわしいでしょ？\
      - ん〜？プレゼントなんだし...ここは高値で買ってもらわないと！風の民は１つの場所に長く留まらないよ。でも誠意があれば話は別。ふふん、どうする？\
      - 本当に隠れるつもりなら、わざわざ目の前に現れるわけないでしょ？\
      "
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
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		--- The below dependencies are optional,
		"hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
		"nvim-telescope/telescope.nvim", -- for file_selector provider telescope
		"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
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
