local wezterm = require("wezterm")
local act = wezterm.action

return {
	keys = {
		{ key = "Enter", mods = "CTRL|SHIFT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) }, --
		{ key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") }, --
		{ key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") }, --
		{ key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") }, --
		{ key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") }, --
	},
	key_tables = {
		copy_mode = {
			--
		},
		search_mode = {
			--
		},
	},
}
