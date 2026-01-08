{ config, lib, ... }:
let
  cfg = config.dot.home;
in
{
  config = lib.mkIf cfg.kdeconnect.enable {
    services.kdeconnect = {
      enable = true;
    };
  };
}
