local wezterm = require("wezterm")
local act = wezterm.action

return {
	keys = {
		{
			key = "1",
			mods = "SHIFT|CTRL",
			action = act.SpawnCommandInNewTab({ args = { "pwsh.exe", "-NoLogo" }, domain = "DefaultDomain" }),
		},
		{
			key = "2",
			mods = "SHIFT|CTRL",
			action = act.SpawnCommandInNewTab({
				args = { "wsl.exe", "-d", "NixOS", "--cd", "~" },
				domain = "DefaultDomain",
			}),
		},
	},
}
