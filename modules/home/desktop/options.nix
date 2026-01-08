# Desktop module options
# All option definitions for dot.home.desktop.*
{ lib, ... }:
{
  options.dot.home.desktop = {
    enable = lib.mkEnableOption "desktop environment (Home Manager)";

    hyprland = {
      enable = lib.mkEnableOption "Hyprland compositor configuration";
    };

    waybar = {
      enable = lib.mkEnableOption "Waybar status bar";
    };

    anyrun = {
      enable = lib.mkEnableOption "Anyrun launcher";
    };

    swaync = {
      enable = lib.mkEnableOption "SwayNC notification center";
    };

    wlogout = {
      enable = lib.mkEnableOption "Wlogout logout menu";
    };

    fcitx5 = {
      enable = lib.mkEnableOption "Fcitx5 input method";
    };

    gnome = {
      enable = lib.mkEnableOption "GNOME desktop configuration";
    };

    keyd = {
      enable = lib.mkEnableOption "Keyd key remapping (Home Manager)";
    };

    xremap = {
      enable = lib.mkEnableOption "Xremap key remapping";
    };

    kanata = {
      enable = lib.mkEnableOption "Kanata key remapping (cross-platform)";
    };

    theme = {
      enable = lib.mkEnableOption "Desktop theme configuration";
    };

    browser = {
      vivaldi = {
        enable = lib.mkEnableOption "Vivaldi browser";
      };
    };
  };
}
