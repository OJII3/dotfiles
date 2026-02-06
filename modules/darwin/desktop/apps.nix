# Homebrew apps configuration
# Applied when dot.darwin.desktop.apps.enable is true
{ config, lib, ... }:
let
  cfg = config.dot.darwin.desktop;
in
{
  config = lib.mkIf (cfg.enable && cfg.apps.enable) {
    homebrew = {
      enable = true;
      onActivation = {
        upgrade = true;
        autoUpdate = false;
        cleanup = "uninstall";
      };
      casks = [
        "affinity"
        "antigravity"
        "chatgpt"
        "discord"
        "figma"
        "firefox"
        "fork"
        "ghostty"
        "karabiner-elements"
        "logi-options+"
        "ltspice"
        "obs"
        "obsidian"
        "parsec"
        "raycast"
        "scroll-reverser"
        "slack"
        "spaceid"
        "steam"
        "unity-hub"
        "visual-studio-code"
        # "docker-desktop"
      ];
      masApps = {
        tailscale = 1475387142;
        # cloudflare-one-agent = 6443476492;
      };
    };
  };
}
