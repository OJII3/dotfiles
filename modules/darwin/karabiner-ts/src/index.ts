import {
	duoLayer,
	ifApp,
	ifVar,
	layer,
	map,
	rule,
	writeToProfile,
} from "karabiner.ts";

const yabai = "/run/current-system/sw/bin/yabai ";

const killLast = `
window_pid=$(${yabai} -m query --windows --window | jq -r '.pid')
app_name=$(${yabai} -m query --windows --window | jq -r '.app')
count_pid=$(${yabai} -m query --windows | jq "[.[] | select(.pid == \${window_pid})] | length")

if [ "$app_name" = "Finder" ]; then
  # For Finder, just close the window without killing the process
  ${yabai} -m window --close
elif [ "$app_name" = "Discord" ]; then
  ${yabai} -m window --close
elif [ "$count_pid" -gt 1 ]; then
  ${yabai} -m window --close
else
  kill "\${window_pid}"
fi
`;

// ! Change '--dry-run' to your Karabiner-Elements Profile name.
// (--dry-run print the config json into console)
// 'Hyper' is ⌘⌥⌃⇧ and 'Meh' is ⌥⌃⇧
writeToProfile("Default profile", [
	// Smart Control without Capslock -------------------------------------
	rule("Smart Capslock")
		.manipulators([
			map("caps_lock").to("left_control"),
			map("caps_lock", "??").to("left_control"),
			map("left_control").to("left_control").toIfAlone("escape"),
		])
		.condition(ifApp("Minecraft").unless()),

	// ---------------------------------------------------------------------
	layer("japanese_kana", "Utility Layer")
		.configKey((v) => v.toIfAlone("fn"), true) // toggle IME to Romaji
		.manipulators([
			map("1").to("`"),
			map("1", "shift").to("`", "shift"),
			map(".").to("keypad_period"),
			map("h").to("left_arrow"),
			map("j").to("down_arrow"),
			map("k").to("up_arrow"),
			map("l").to("right_arrow"),
		]),

	//---------------------------------------------------------------------
	layer("japanese_eisuu", "super")
		// .configKey((v) => v.toIfAlone("spacebar", "left_option"), true)
		.manipulators([
			// focus window
			map("h").to$(yabai + "-m window --focus west"),
			map("j").to$(yabai + "-m window --focus south"),
			map("k").to$(yabai + "-m window --focus north"),
			map("l").to$(yabai + "-m window --focus east"),
			// move wndow
			map("h", "shift").to$(yabai + "-m window --warp west"),
			map("j", "shift").to$(yabai + "-m window --warp south"),
			map("k", "shift").to$(yabai + "-m window --warp north"),
			map("l", "shift").to$(yabai + "-m window --warp east"),
			// focus space
			map("1").to("1", "control"),
			map("2").to("2", "control"),
			map("3").to("3", "control"),
			map("4").to("4", "control"),
			map("5").to("5", "control"),
			// move window to space
			map("1", "shift").to$(yabai + "-m window --space 1"),
			map("2", "shift").to$(yabai + "-m window --space 2"),
			map("3", "shift").to$(yabai + "-m window --space 3"),
			map("4", "shift").to$(yabai + "-m window --space 4"),
			map("5", "shift").to$(yabai + "-m window --space 5"),
			// other window operations -------------------------------------
			map("tab").to$(yabai + "-m window --focus recent"),
			map("q").to$(killLast),
			map("f", "shift").to$(
				`${yabai}-m window --toggle float --grid 4:4:1:1:2:2`,
			),
			map("w").to$(
				`${yabai}-m window --toggle float; ${yabai}-m window --grid 1:1:0:0:1:1`,
			),

			// Utilities -------------------------------------------------
			map("m").to("up_arrow", "command"), // Mission Control (default)
			map("n").to("down_arrow", "command"), // Notification Center (not a default, can be set in Settings)

			// launch  applications -------------------------------------
			map("return_or_enter").to$("/usr/bin/open -a kitty ~"),
			map("spacebar").to("spacebar", "left_option"),
			map("g").to$(
				"$HOME/Applications/Home\\ Manager\\ Apps/Google\\ Chrome.app/Contents/MacOS/Google\\ Chrome --args --kiosk && sleep 1",
			),
			map("o").to$(
				"$HOME/Applications/Home\\ Manager\\ Apps/Google\\ Chrome.app/Contents/MacOS/Google\\ Chrome --args --profile-directory=Default && sleep 1",
			),
			map("i").toApp("System Settings"),
			map("e").toApp("Finder"),

			// Genral Key Complements & Replacements ------------------------
			map("1").to("`"),
			map("2").to("`", "shift"),

			// for Minecraft
			map("a").to("f13"),
			map("s").to("f14"),
			map("d").to("f15"),
			map("f").to("f16"),
		]),

	// Application specific mappings -------------------------------------
	rule("chrome")
		.manipulators([
			map("w", "control").to("w", "command"),
			map("t", "control").to("t", "command"),
			map("l", "control").to("l", "command"),
		])
		.condition(ifApp("Chrome")),

	// for Minecraft
	// duoLayer("e", "f").manipulators([map("q").to("f13"), map("w").to("f14")]),

	rule("Conditions", ifApp("^com.apple.finder$")).manipulators([
		map(0).to(1).condition(ifVar("vi-mode"), ifVar("stop").unless()),
	]),
]);
