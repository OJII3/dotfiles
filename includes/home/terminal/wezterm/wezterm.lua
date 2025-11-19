-- Pull in the wezterm API
local wezterm = require("wezterm")
local images = require("local.images")
local local_keybindings = require("local.keybindings")

-- This table will hold the configuration.
local config = wezterm.config_builder()

-- config.color_scheme = "Tokyo Night"
config.color_scheme = "Github Dark (Gogh)"
config.initial_rows = 40
config.initial_cols = 160
config.font_size = 11
config.font = wezterm.font_with_fallback({
	"UDEV Gothic 35NF",
	"JetBrains Mono",
	"Symbols Nerd Font",
	"Noto Color Emoji",
})
config.inactive_pane_hsb = {
	brightness = 0.8,
}
config.enable_scroll_bar = true
config.background = {
	{
		source = {
			File = images.silver_wolf,
		},
		horizontal_align = "Center",
		repeat_x = "NoRepeat",
		opacity = 0.8,
		-- hsb = { brightness = 0.06 },
	},
	{
		source = {
			Gradient = {
				colors = { "#000000cc", "#33337899" },
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
config.hide_tab_bar_if_only_one_tab = false
config.window_frame = {
	font_size = 10,
}

local launch_menu = {}
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	table.insert(launch_menu, {
		label = "PowerShell",
		args = { "powershell.exe", "-NoLogo" },
	})

	config.default_prog = { "pwsh.exe", "-NoLogo" }
end

-- keymap ------------------------------------------------
config.disable_default_key_bindings = trues
config.keys = require("keybindings").keys
for _, binding in ipairs(local_keybindings.keys) do
	table.insert(config.keys, binding)
end

return config
