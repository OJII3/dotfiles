{ config, lib, pkgs, ... }:
let
  cfg = config.dot.home.desktop;
in
{
  config = lib.mkIf cfg.fcitx5.enable {
    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5.waylandFrontend = true;
      fcitx5.addons = with pkgs; [
        fcitx5-mozc
        fcitx5-gtk
        fcitx5-skk
      ];
    };

    home.packages = with pkgs; [
      skkDictionaries.l
      skktools
    ];

    home.file.".config/libskk" = {
      source = ./config/libskk;
      recursive = true;
    };
  };
}
