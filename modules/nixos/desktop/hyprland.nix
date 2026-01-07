# Hyprland compositor configuration
{ config, lib, pkgs, ... }:
let
  cfg = config.my.desktop;
in
{
  config = lib.mkIf (cfg.enable && cfg.hyprland.enable) {
    environment.systemPackages = [ pkgs.canta-theme ];

    services.xserver.xkb = {
      variant = "";
      layout = "us";
    };

    programs.uwsm.enable = true;
    programs.hyprland = {
      enable = true;
      withUWSM = true;
    };

    qt.style = "kvantum";
  };
}
