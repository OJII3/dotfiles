import { ifApp, ifVar, layer, map, rule, writeToProfile } from "karabiner.ts";

// ! Change '--dry-run' to your Karabiner-Elements Profile name.
// (--dry-run print the config json into console)
// 'Hyper' is ⌘⌥⌃⇧ and 'Meh' is ⌥⌃⇧
writeToProfile("Default profile", [
  // ---------------------------------------------------------------------
  rule("Smart Control & CapsLock")
    .manipulators([
      map("caps_lock", "??").to("fn"),
      // for Vim
      map("left_control").to("left_control").toIfAlone("escape"),
    ])
    .condition(ifApp("Minecraft").unless()),

  // ---------------------------------------------------------------------
  layer("japanese_kana", "Utility Layer")
    .configKey((v) => v.toIfAlone("fn"), true) // toggle IME to Romaji
    .manipulators([
      map("h").to("left_arrow"),
      map("j").to("down_arrow"),
      map("k").to("up_arrow"),
      map("l").to("right_arrow"),
      map("f").toPointingButton("button1"), // left click
      // map("0").to("keypad_0"),
      // map("1", "shift").to("`", "shift"),
      // map(".").to("keypad_period"),
      // map("h").to("left_arrow"),
      // map("j").to("down_arrow"),
      // map("k").to("up_arrow"),
      // map("l").to("right_arrow"),
    ]),

  // Make IME toggle key near the thumb
  rule("Right Command").manipulators([map("right_command").toIfAlone("fn")]),
  rule("Additional Backspae").manipulators([
    map("international3").to("delete_or_backspace"),
  ]),

  // Additional Option key near the thumb
  layer("japanese_eisuu", "Utility Layer")
    .configKey((v) => v.to("left_option"), true)
    .configKey((v) => v.toIfAlone("`"), true) // missing key on Mac's JP keyboard
    .manipulators([]),
  rule("~").manipulators([map("japanese_eisuu", "shift").to("`", "shift")]), // missing key on Mac's JP keyboard

  rule("Left Option to Right Option").manipulators([
    // You can use the left option key as a right option key (normal option key)
    map("left_option", "??").to("right_option"),
  ]),

  rule("Alt").manipulators([
    // System operations -------------------------------------
    map("m", "left_option").to("↑", "command"), // Mission Control (Default)
    map("n", "left_option").to("↓", "command"), // Notification Center (not Default)

    // Launch applications -------------------------------------
    map("i", "left_option").toApp("System Settings"),
    map("e", "left_option").toApp("Finder"),
    // map("return_or_enter", "left_option").to$("/usr/bin/open -a kitty ~"),
    // map("g", "left_option").to$(
    //   "/Applications/Google\\ Chrome.app/Contents/MacOS/Google\\ Chrome --args --kiosk && sleep 1",
    // ),
    // map("o", "left_option").to$(
    //   "/Applications/Google\\ Chrome.app/Contents/MacOS/Google\\ Chrome --args --profile-directory=Default && sleep 1",
    // ),
  ]),

  // Application specific mappings -------------------------------------
  rule("chrome")
    .manipulators([
      map("w", "control").to("w", "command"),
      map("t", "control").to("t", "command"),
      map("t", "control").to("t", "command"),
      map("l", "control").to("l", "command"),
    ])
    .condition(ifApp("Chrome")),

  rule("Conditions", ifApp("^com.apple.finder$")).manipulators([
    map(0).to(1).condition(ifVar("vi-mode"), ifVar("stop").unless()),
  ]),
]);
