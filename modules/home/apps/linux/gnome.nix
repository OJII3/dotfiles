{ config, lib, ... }:
let
  cfg = config.dot.home.apps.linux;
in
{
  config = lib.mkIf cfg.gnome.enable {
    programs.firefox.enable = true;
  };
}
