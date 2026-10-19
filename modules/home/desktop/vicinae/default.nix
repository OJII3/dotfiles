{ config, lib, ... }:
let
  cfg = config.dot.home.desktop;
in
{
  config = lib.mkIf (cfg.gnome.enable || cfg.vicinae.enable) {
    programs.vicinae = {
      enable = true;
      systemd = {
        enable = true;
      };
    };
  };
}
