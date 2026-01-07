{ config, lib, ... }:
let
  cfg = config.my.home;
in
{
  config = lib.mkIf cfg.kdeconnect.enable {
    services.kdeconnect = {
      enable = true;
    };
  };
}
