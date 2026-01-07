# Networking configuration
# Applied when my.darwin.core.networking.enable is true
{ config, lib, ... }:
let
  cfg = config.my.darwin.core;
in
{
  config = lib.mkIf (cfg.enable && cfg.networking.enable) {
    networking.knownNetworkServices = [
      "USB 10/100/1000 LAN"
      "Thunderbolt Bridge"
      "Wi-Fi"
    ];
    homebrew.masApps = {
      tailscale = 1475387142;
    };
    environment.shellAliases = {
      tailscale = "/Applications/Tailscale.app/Contents/MacOS/Tailscale";
    };
    services.openssh.enable = true;
  };
}
