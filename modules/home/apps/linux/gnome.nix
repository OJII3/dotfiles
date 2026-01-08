{ config, lib, ... }:
let
  cfg = config.my.home.apps.linux;
in
{
  config = lib.mkIf cfg.gnome.enable {
    programs.firefox.enable = true;
  };
}
