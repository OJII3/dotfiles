import { ifApp, ifVar, layer, map, rule, writeToProfile } from "karabiner.ts";
import { closeWindow, yabai } from "./commands";

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
      map("0").to("keypad_0"),
      map("1", "shift").to("`", "shift"),
      map(".").to("keypad_period"),
      map("h").to("left_arrow"),
      map("j").to("down_arrow"),
      map("k").to("up_arrow"),
      map("l").to("right_arrow"),
    ]),

  // Make IME toggle key near the thumb
  rule("Right Command").manipulators([map("right_command").toIfAlone("fn")]),

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
    // focus window
    // map("h", "left_option").to$(`${yabai} -m window --focus west`),
    // map("j", "left_option").to$(`${yabai} -m window --focus south`),
    // map("k", "left_option").to$(`${yabai} -m window --focus north`),
    // map("l", "left_option").to$(`${yabai} -m window --focus east`),
    // move wndow
    // map("h", "left_option", "shift").to$(`${yabai} -m window --warp west`),
    // map("j", "left_option", "shift").to$(`${yabai} -m window --warp south`),
    // map("k", "left_option", "shift").to$(`${yabai} -m window --warp north`),
    // map("l", "left_option", "shift").to$(`${yabai} -m window --warp east`),
    // focus space
    map("1", "left_option").to("1", "control"),
    map("2", "left_option").to("2", "control"),
    map("3", "left_option").to("3", "control"),
    map("4", "left_option").to("4", "control"),
    map("5", "left_option").to("5", "control"),
    // move window to space
    // map("1", "left_option", "shift").to$(`${yabai} -m window --space 1`),
    // map("2", "left_option", "shift").to$(`${yabai} -m window --space 2`),
    // map("3", "left_option", "shift").to$(`${yabai} -m window --space 3`),
    // map("4", "left_option", "shift").to$(`${yabai} -m window --space 4`),
    // map("5", "left_option", "shift").to$(`${yabai} -m window --space 5`),
    // other window operations -------------------------------------
    map("tab", "left_option").to$(`${yabai}-m window --focus recent`),
    map("q", "left_option").to$(closeWindow),
    map("f", "left_option", "shift").to$(
      `${yabai}-m window --toggle float --grid 4:4:1:1:2:2`,
    ),
    map("w", "left_option").to$(
      `${yabai} -m window --toggle float; ${yabai} -m window --grid 1:1:0:0:1:1`,
    ),

    // System operations -------------------------------------
    map("m", "left_option").to("↑", "command"), // Mission Control (Default)
    map("n", "left_option").to("↓", "command"), // Notification Center (not Default)

    // Launch applications -------------------------------------
    map("i", "left_option").toApp("System Settings"),
    map("e", "left_option").toApp("Finder"),
    map("return_or_enter", "left_option").to$("/usr/bin/open -a kitty ~"),
    map("g", "left_option").to$(
      "/Applications/Google\\ Chrome.app/Contents/MacOS/Google\\ Chrome --args --kiosk && sleep 1",
    ),
    map("o", "left_option").to$(
      "/Applications/Google\\ Chrome.app/Contents/MacOS/Google\\ Chrome --args --profile-directory=Default && sleep 1",
    ),
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
