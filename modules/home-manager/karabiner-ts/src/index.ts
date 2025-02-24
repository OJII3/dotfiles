import {
	type NumberKeyValue,
	ifApp,
	ifInputSource,
	ifKeyboardType,
	ifVar,
	layer,
	map,
	mapDoubleTap,
	rule,
	simlayer,
	withCondition,
	withMapper,
	writeToProfile,
} from "karabiner.ts";

const yabai = "/run/current-system/sw/bin/yabai ";

// ! Change '--dry-run' to your Karabiner-Elements Profile name.
// (--dry-run print the config json into console)
writeToProfile("Default profile", [
	rule("IME-toggle").manipulators([
		map("japanese_kana")
			.to("japanese_eisuu")
			.condition(ifInputSource({ language: "ja" })),
	]),

	// 'Hyper' is ⌘⌥⌃⇧ and 'Meh' is ⌥⌃⇧
	rule("Modifiers").manipulators([
		map("caps_lock").to("left_command"),
		map("left_control").to("left_control").toIfAlone("escape"),
	]),

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
			map("1").to$(yabai + "-m space --focus 1"),
			map("2").to$(yabai + "-m space --focus 2"),
			map("3").to$(yabai + "-m space --focus 3"),
			map("4").to$(yabai + "-m space --focus 4"),
			// move window to space
			map("1", "shift").to$(yabai + "-m window --space 1"),
			map("2", "shift").to$(yabai + "-m window --space 2"),
			map("3", "shift").to$(yabai + "-m window --space 3"),
			map("4", "shift").to$(yabai + "-m window --space 4"),
			// other window operations
			map("tab").to$(yabai + "-m window --focus last"),
			map("q").to$(yabai + "-m window --close"),
			//  applications
			map("f", "shift").to$(
				yabai + "-m window --toggle float --grid 4:4:1:1:2:2",
			),
			map("w").to$(
				yabai +
					"-m window --toggle float;" +
					yabai +
					"-m window --grid 1:1:0:0:1:1",
			),
			map("return_or_enter").to$("$HOME/.nix-profile/bin/kitty"),
			map("o").to$(
				"$HOME/.nix-profile/bin/google-chrome-stable --profile-directory=Default",
			),
		]),

	// Application specific mappings
	rule("chrome")
		.manipulators([
			map("w", "control").to("w", "command"),
			map("t", "control").to("t", "command"),
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
		mapDoubleTap(1).to("w", "⌘"),
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
