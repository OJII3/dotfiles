{ config, lib, ... }:
let
  cfg = config.dot.darwin.networking;
in
{
  config = lib.mkIf cfg.enable {
    networking.knownNetworkServices = [
      "USB 10/100/1000 LAN"
      "Thunderbolt Bridge"
      "Wi-Fi"
    ];
  };
}
