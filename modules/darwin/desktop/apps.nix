# Homebrew apps configuration
# Applied when dot.darwin.desktop.apps.enable is true
{ config, lib, ... }:
let
  cfg = config.dot.darwin.desktop;
in
{
  config = lib.mkIf (cfg.enable && cfg.apps.enable) {
    assertions = [
      {
        assertion = config.homebrew.enable;
        message = "dot.darwin.desktop.apps requires homebrew to be enabled (set dot.darwin.core.enable = true)";
      }
    ];
    homebrew.casks = [
      "affinity"
      "chatgpt"
      "codex-app"
      "discord"
      "figma"
      "firefox"
      "fork"
      "ghostty"
      "logi-options+"
      "minecraft"
      "moonlight"
      "obs"
      "opencode-desktop"
      "parsec"
      "raycast"
      "scroll-reverser"
      "slack"
      "spaceid"
      "steam"
      "telegram"
      "unity-hub"
    ];
  };
}
