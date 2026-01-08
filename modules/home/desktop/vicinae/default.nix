{ config, lib, ... }:
let
  cfg = config.dot.home.desktop;
in
{
  # vicinae is used with gnome
  config = lib.mkIf cfg.gnome.enable {
    programs.vicinae = {
      enable = true;
      systemd = {
        enable = true;
      };
    };
  };
}
