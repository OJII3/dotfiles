{ config, lib, ... }:
let
  cfg = config.my.home.desktop;
in
{
  # hypr (hyprpaper, hyprlock, hypridle) is part of hyprland
  config = lib.mkIf cfg.hyprland.enable {
    services.hyprpaper.enable = true;
    programs.hyprlock.enable = true;

    home.file.".config/hypr/hyprlock.conf".source = ./hyprlock.conf;
    home.file.".config/hypr/hypridle.conf".source = ./hypridle.conf;
    home.file.".config/hypr/hyprpaper.conf".source = ./hyprpaper.conf;
  };
}
