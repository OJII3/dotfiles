# Terminal module options
# All option definitions for my.home.terminal.*
{ lib, ... }:
{
  options.my.home.terminal = {
    enable = lib.mkEnableOption "terminal emulators";

    kitty = {
      enable = lib.mkEnableOption "Kitty terminal";
    };

    ghostty = {
      enable = lib.mkEnableOption "Ghostty terminal";
    };

    wezterm = {
      enable = lib.mkEnableOption "WezTerm terminal";
    };
  };
}
