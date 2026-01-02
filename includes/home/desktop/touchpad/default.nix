{ config, lib, pkgs, ... }:

let
  # Create Python environment with required packages
  pythonEnv = pkgs.python3.withPackages (ps: with ps; [
    evdev
  ]);

  # Create wrapper script that uses the correct Python environment
  touchpadFilter = pkgs.writeShellScriptBin "touchpad-filter" ''
    exec ${pythonEnv}/bin/python3 ${./touchpad-filter.py} "$@"
  '';
in
{
  home.packages = [
    touchpadFilter
  ];

  # Create systemd user service
  systemd.user.services.touchpad-filter = {
    Unit = {
      Description = "Advanced Touchpad Filter Daemon";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      Type = "simple";
      ExecStart = "${touchpadFilter}/bin/touchpad-filter -v";
      Restart = "on-failure";
      RestartSec = "5s";
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  # Note: User needs to be in 'input' group for device access
  # Add this to your NixOS configuration:
  # users.users.<your-username>.extraGroups = [ "input" ];
}
