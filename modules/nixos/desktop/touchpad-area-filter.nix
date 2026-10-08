{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dot.desktop;
  enabled = cfg.gnome.enable && cfg.gnome.touchpad.topDeadZoneMm > 0;
  python = pkgs.python3.withPackages (packages: [ packages.evdev ]);
in
{
  config = lib.mkIf enabled {
    systemd.services.touchpad-area-filter = {
      description = "Filter contacts from the top edge of the touchpad";
      wantedBy = [ "graphical.target" ];
      after = [ "systemd-udev-settle.service" ];

      serviceConfig = {
        Type = "simple";
        User = config.dot.core.user.name;
        SupplementaryGroups = [ "input" ];
        ExecStart = "${python}/bin/python ${./touchpad-area-filter.py} --device /dev/input/by-path/platform-AMDI0010:01-event-mouse --top-dead-zone-mm ${toString cfg.gnome.touchpad.topDeadZoneMm}";
        Restart = "on-failure";
        RestartSec = 2;
      };
    };
  };
}
