return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		{ "nvim-lua/plenary.nvim" },
		{ "nvim-tree/nvim-web-devicons" }, -- not strictly required, but recommended
	},
	keys = {
		{ "<Space>fg", "<cmd>Telescope git_files<CR>" },
		{ "<Space>ff", "<cmd>Telescope find_files<CR>" },
		{ "<Space>fo", "<cmd>Telescope oldfiles<CR>" },
		{ "<Space>fr", "<cmd>Telescope live_grep<CR>" },
		{ "<C-\\>", "<C-c>", mode = "i" },
	},
}
