import {
	ifApp,
	ifVar,
	layer,
	map,
	rule,
	withCondition,
	withMapper,
	writeToProfile,
} from "karabiner.ts";

const yabai = "/run/current-system/sw/bin/yabai ";

// ! Change '--dry-run' to your Karabiner-Elements Profile name.
// (--dry-run print the config json into console)
// 'Hyper' is ⌘⌥⌃⇧ and 'Meh' is ⌥⌃⇧
writeToProfile("Default profile", [
	// Smart Control without Capslock ----------------------------------
	rule("Smart Capslock").manipulators([
		map("caps_lock").to("left_command"),
		map("left_control").to("left_control").toIfAlone("escape"),
	]),
	// ---------------------------------------------------------------------
	layer("japanese_kana", "Utility Layer")
		.configKey((v) => v.toIfAlone("fn")) // toggle IME
		.manipulators([
			map("1").to("`"),
			map("1", "shift").to("`", "shift"),
			map("h").to("left_arrow"),
			map("j").to("down_arrow"),
			map("k").to("up_arrow"),
			map("l").to("right_arrow"),
		]),

	// Disable system shortcuts
	rule("Disable-system").manipulators([map("q", "command").toNone()]),

	layer("japanese_eisuu", "super")
		.configKey((v) => v.toIfAlone("spacebar", "command"), true)
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
			// map("1").to$(yabai + "-m space --focus 1"),
			// map("2").to$(yabai + "-m space --focus 2"),
			// map("3").to$(yabai + "-m space --focus 3"),
			// map("4").to$(yabai + "-m space --focus 4"),
			// move window to space
			// map("1", "shift").to$(yabai + "-m window --space 1"),
			// map("2", "shift").to$(yabai + "-m window --space 2"),
			// map("3", "shift").to$(yabai + "-m window --space 3"),
			// map("4", "shift").to$(yabai + "-m window --space 4"),
			//
			// other window operations
			map("tab").to$(yabai + "-m window --focus recent"),
			map("q").to$(yabai + "-m window --close"),
			map("f", "shift").to$(
				yabai + "-m window --toggle float --grid 4:4:1:1:2:2",
			),
			map("w").to$(
				yabai +
					"-m window --toggle float;" +
					yabai +
					"-m window --grid 1:1:0:0:1:1",
			),
			// launch  applications ----------------
			map("return_or_enter").to$("/usr/bin/open -a kitty ~"),
			map("o").to$(
				"$HOME/.nix-profile/bin/google-chrome-stable --profile-directory=Default",
			),
			map("i").to$("/usr/bin/open -a System Settings"),
			map("e").to$("/usr/bin/open -a Finder"),
		]),

	// Application specific mappings
	rule("chrome")
		.manipulators([
			map("w", "control").to("w", "command"),
			map("t", "control").to("t", "command"),
			map("l", "control").to("l", "command"),
		])
		.condition(ifApp("Chrome")),

	rule("Conditions", ifApp("^com.apple.finder$")).manipulators([
		map(0).to(1).condition(ifVar("vi-mode"), ifVar("stop").unless()),
	]),

	// Optional parameters can be set when use
	// - from.simultaneous  - basic.simultaneous_threshold_milliseconds
	// - to_if_alone        - basic.to_if_alone_timeout_milliseconds
	// - to_if_held_down    - basic.to_if_held_down_threshold_milliseconds
	// - to_delayed_action  - basic.to_delayed_action_delay_milliseconds
	rule("Parameters").manipulators([
		map("left_option")
			.toIfAlone("r", "⌘")
			.parameters({ "basic.to_if_alone_timeout_milliseconds": 500 }),
	]),

	// There are some other useful abstractions over the json config.
	// [File an issue](https://github.com/evan-liu/karabiner.ts/issues) to suggest more.
	rule("Other abstractions").manipulators([
		// Move the mouse cursor to a position and (optionally) to a screen.
		map("↑", "Meh").toMouseCursorPosition({ x: "100%", y: 0 }),
		map("→", "Meh").toMouseCursorPosition({ x: "50%", y: "50%", screen: 1 }),
	]),

	// There are also some useful utilities
	rule("Utility").manipulators([
		// For nested conditions inside rules/layers
		map(0)
			.to(1)
			.condition(ifVar("a")),
		// You can group them using withCondition()
		withCondition(ifVar("a"))([
			map(0).to(1),
			map(1)
				.to(2)
				.condition(ifApp("X").unless()), // And nest more conditions.
		]),

		// Use withMapper() to apply the same mapping
		withMapper({ c: "Calendar", f: "Finder" })((k, v) =>
			map(k, "Meh").toApp(v),
		),

		// And some others like double-tap
	]),
]);

/*
Karabiner-Elements profile parameters can also be set by the 3rd parameter
of writeToProfile('profileName', [ rules ], { params }). The default values are:

// Karabiner-Elements parameters
'basic.to_if_alone_timeout_milliseconds': 1000,
'basic.to_if_held_down_threshold_milliseconds': 500,
'basic.to_delayed_action_delay_milliseconds': 500,
'basic.simultaneous_threshold_milliseconds': 50,
'mouse_motion_to_scroll.speed': 100,

// karabiner.ts only parameters
//   for simlayer()
'simlayer.threshold_milliseconds': 200
//   for mapDoubleTap()
'double_tap.delay_milliseconds': 200,

 */
