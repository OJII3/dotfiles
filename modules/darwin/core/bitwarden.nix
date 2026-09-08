{ config, lib, ... }:
let
  cfg = config.dot.darwin.core;
in
{
  config = lib.mkIf (cfg.enable && cfg.bitwarden.enable) {
    assertions = [
      {
        assertion = config.homebrew.enable;
        message = "dot.darwin.networking.tailscale requires homebrew to be enabled (set dot.darwin.core.enable = true)";
      }
    ];
    homebrew.masApps = {
      bitwarden = 1352778147;
    };
  };
}
