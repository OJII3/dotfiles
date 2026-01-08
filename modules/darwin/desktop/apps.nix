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
        "SpaceId"
        "affinity"
        "figma"
        "firefox"
        "fork"
        "ghostty"
        "logi-options+"
        "ltspice"
        "obs"
        "scroll-reverser"
        "steam"
        "unity-hub"
        "visual-studio-code"
        # "chatgpt"
        # "docker-desktop"
        # "raycast"
        # "slack"
      ];
      masApps = {
        tailscale = 1475387142;
        # cloudflare-one-agent = 6443476492;
      };
    };
  };
}
