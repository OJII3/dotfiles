{ config, lib, pkgs, ... }:
let
  cfg = config.dot.home.desktop;
in
{
  config = lib.mkIf cfg.xremap.enable {
    systemd.user.services.xremap = {
      Unit = {
        Description = "XRemap Service";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.xremap}/bin/xremap ${./config.yml}";
        Restart = "on-failure";
        RestartSec = 5;
      };
    };
  };
}
