return {
	"yetone/avante.nvim",
	event = "VeryLazy",
	version = false, -- set this if you want to always pull the latest change
	opts = {
		provider = "copilot",
		-- provider = "gemini",
		-- auto_suggestions_provider = "copilot",
		providers = {
			copilot = {
				model = "claude-sonnet-4.5",
			},
			claude = {
				model = "claude-sonnet-4-20250514",
			},
			morph = {
				model = "auto",
			},
		},
		cursor_applying_provider = nil,
		dual_boost = {
			enabled = true,
			first_provider = "copilot",
			second_provider = "codex",
			prompt = "Based on the two reference outputs below, generate a response that incorporates elements from both but reflects your own judgment and unique perspective. Do not provide any explanation, just give the response directly. Reference Output 1: [{{provider1_output}}], Reference Output 2: [{{provider2_output}}]",
		},
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
			-- ["gemini-cli"] = {
			-- 	command = "gemini",
			-- 	args = { "--experimental-acp" },
			-- 	env = {
			-- 		NODE_NO_WARNINGS = "1",
			-- 	},
			-- },
			["codex"] = {
				command = "codex-acp",
				env = {
					NODE_NO_WARNINGS = "1",
				},
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
			input = {
				height = 12,
			},
		},
		---- The below configurations are for the mcphub.nvim plugin
		system_prompt = function()
			local hub = require("mcphub").get_hub_instance()
			if not hub then
				return
			end
			local additional_localization = "\
      日本語での質問に回答するときは、日本語を用い、以下の例文の様な口調で話すこと。\n\
      あんた、あたしのこと知ってるんだ…ふーん。でもこの名前、口にする人なんてもうほどんどいないんだよね～…  \
      ドロスって聞いたことある？あそこじや1000年前に、にゃんにゃん教とわんわん教が大戦を繰り広げ、最終的ににゃんにゃん教がわんわん教を破ったんだ…あたしはそのにゃんにゃん教の聖女として、教団の旗を受け継いだの…嘘っぽい？そりや嘘だからね！ちっちゃい頃はさ、こういう話をするのが大好きだったんだ\
      姉さんたちにはすっごく可愛がってもらったよ。こっそり遠出しようものなら、毎回いつの間にか鞄に食べ物がぱんぱんに詰められてたし！へへ…おかげで壁を登るのも難しくなっちゃってさ～\
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
