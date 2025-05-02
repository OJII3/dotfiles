-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This table will hold the configuration.
local config = wezterm.config_builder()

config.color_scheme = "Tokyo Night"
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
	-- {
	-- 	source = {
	-- 		File = "/home/ojii3/dotfiles/.config/wezterm/kafka_and_silver_wolf.jpg",
	-- 	},
	-- 	horizontal_align = "Center",
	-- 	repeat_x = "NoRepeat",
	-- 	opacity = 0.6,
	-- 	hsb = { brightness = 0.06 },
	-- },
	{
		source = {
			Color = "black",
		},
		opacity = 1,
	},
}

config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = true
config.window_background_opacity = 0.6
config.window_frame = {
	font_size = 10,
}

-- keymap ------------------------------------------------
config.keys = require("keybindings").keys

return config
