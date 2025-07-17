-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This table will hold the configuration.
local config = wezterm.config_builder()

-- config.color_scheme = "Tokyo Night"
config.color_scheme = "Github Light (Gogh)"
config.initial_rows = 120
config.initial_cols = 280
config.font_size = 11
config.font = wezterm.font_with_fallback({
	"HackGen35 Console NF",
	"JetBrains Mono",
	"Symbols Nerd Font",
	"Noto Color Emoji",
})
config.inactive_pane_hsb = {
	brightness = 0.8,
}
config.enable_scroll_bar = true
-- config.colors = {
-- scrollbar_thumb = "#333333",
-- }

config.background = {
	{
		source = {
			File = "/home/ojii3/.assets/images/honkai_everyone.png",
		},
		horizontal_align = "Center",
		repeat_x = "NoRepeat",
		opacity = 1,
		-- hsb = { brightness = 0.06 },
	},
	{
		source = {
			Gradient = {
				colors = { "#ffffff88", "#eeeeff33" },
				orientation = {
					Linear = { angle = -30.0 },
				},
			},
		},
		opacity = 1,
		width = "100%",
		height = "100%",
	},
	-- {
	-- 	source = {
	-- 		Color = "white",
	-- 	},
	-- 	opacity = 1,
	-- },
}

config.use_fancy_tab_bar = true
config.tab_bar_at_bottom = false
config.hide_tab_bar_if_only_one_tab = true
config.window_frame = {
	font_size = 10,
}

-- keymap ------------------------------------------------
config.keys = require("keybindings").keys

return config
