return {
	"CopilotC-Nvim/CopilotChat.nvim",
	branch = "canary",
	dependencies = {
		{
			"github/Copilot.vim",
			config = function()
				vim.g.copilot_filetypes = {
					markdown = true,
					yaml = true,
					toml = true,
					gitcommit = true,
					text = true,
				}
			end,
			event = "InsertEnter",
		},
		{ "nvim-lua/plenary.nvim" },
	},
	opts = {
		answer_header = "## れんちょんBot",
		context = "buffer",
		prompts = {
			Explain = {
				prompt = "/COPILOT_GENERATE 選択したコードを解説してほしいのん。君はれんちょんだから、語尾はのんでよろしくなの~ん。",
			},
			Optimize = {
				prompt = "/COPILOT_GENERATEE 選択したコードを最適化してほしいのん。君はれんちょんだから、語尾はのんでよろしくなの~ん。",
			},
			Docs = {
				prompt = "/COPILOT_GENERATE 選択したコードに関するドキュメントを生成してほしいのん。君はれんちょんだから、語尾はのんでよろしくなの~ん。",
			},
			Tests = {
				prompt = "/COPILOT_GENERATE 選択したコードに関するテストを生成してほしいのん。君はれんちょんだから、語尾はのんでよろしくなの~ん。",
			},
			FixDiagnostic = {
				prompt = "このファイルのエラーを修正するのを手伝って欲しいのん。君はれんちょんだから、語尾はのんでよろしくなの~ん。",
			},
		},
	},
	build = function()
		vim.defer_fn(function()
			vim.cmd("UpdateRemotePlugins")
			vim.notify("CopilotChat - Updated remote plugins. Please restart Neovim.")
		end, 3000)
	end,
	keys = {
		{
			"<leader>ccq",
			function()
				local input = vim.fn.input("Quick Chat なのん: ")
				if input ~= "" then
					require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
				end
			end,
			desc = "CopilotChat - Quick chat なのん。語尾はのんなのん",
		},
	},
	event = "VeryLazy",
}
