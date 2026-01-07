{ config, lib, ... }:
let
  cfg = config.my.home.desktop;
in
{
  # uwsm is part of hyprland configuration
  config = lib.mkIf cfg.hyprland.enable {
    home.file.".config/uwsm/env".source = ./env;
  };
}
