{
  config,
  lib,
  hostname,
  ...
}:
let
  cfg = config.dot.darwin.networking;
in
{
  config = lib.mkIf cfg.enable {
    networking = {
      search = [ "internal.ojii3.dev" ];
      hostName = hostname;
      knownNetworkServices = [
        "USB 10/100/1000 LAN"
        "Thunderbolt Bridge"
        "Wi-Fi"
      ];
    };
  };
}
