# Sunshine remote desktop configuration
{ config, lib, ... }:
let
  cfg = config.my.desktop;
in
{
  config = lib.mkIf (cfg.enable && cfg.sunshine.enable) {
    services.sunshine = {
      enable = true;
      openFirewall = true;
      autoStart = true;
      capSysAdmin = true;
    };
    systemd.user.services.sunshine = {
      wantedBy = [ "graphical.target" ];
    };
  };
}
