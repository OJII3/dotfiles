# Hyprland compositor configuration
{
  config,
  lib,
  ...
}:
let
  cfg = config.dot.desktop;
in
{
  config = lib.mkIf (cfg.enable && cfg.hyprland.enable) {
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
