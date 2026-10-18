{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dot.home.apps.linux.openlogi;
in
{
  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.openlogi ];

    systemd.user.services.openlogi-agent = {
      Unit = {
        Description = "OpenLogi background agent";
        After = [ "graphical-session.target" ];
        PartOf = lib.optionals cfg.launchAtLogin [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = lib.getExe' pkgs.openlogi "openlogi-agent";
        Restart = "on-failure";
        RestartSec = 5;
      };
      Install.WantedBy = lib.optionals cfg.launchAtLogin [ "graphical-session.target" ];
    };
  };
}
