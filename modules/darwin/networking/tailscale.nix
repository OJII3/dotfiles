{ config, lib, ... }:
let
  cfg = config.dot.darwin.networking;
in
{
  config = lib.mkIf (cfg.enable && cfg.tailscale.enable) {
    homebrew.masApps = {
      tailscale = 1475387142;
    };
    environment.shellAliases = {
      tailscale = "/Applications/Tailscale.app/Contents/MacOS/Tailscale";
    };
  };
}
