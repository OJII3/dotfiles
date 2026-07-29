{ config, lib, ... }:
let
  cfg = config.dot.darwin.networking;
in
{
  config = lib.mkIf (cfg.enable && cfg.tailscale.enable) {
    assertions = [
      {
        assertion = config.homebrew.enable;
        message = "dot.darwin.networking.tailscale requires homebrew to be enabled (set dot.darwin.core.enable = true)";
      }
    ];
    homebrew.masApps = {
      tailscale = 1475387142;
    };
    environment.shellAliases = {
      tailscale = "/Applications/Tailscale.app/Contents/MacOS/Tailscale";
    };
  };
}
