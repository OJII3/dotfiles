{ config, lib, ... }:
let
  cfg = config.dot.home.desktop;
in
{
  config = lib.mkIf cfg.waybar.enable {
    programs.waybar = {
      enable = true;
      systemd.enable = true;
    };

    home.file.".config/waybar/config.jsonc".source = ./config.jsonc;
    home.file.".config/waybar/style.css".source = ./style.css;
  };
}
