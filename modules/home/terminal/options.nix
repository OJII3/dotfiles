# Terminal module options
# All option definitions for dot.home.terminal.*
{ lib, ... }:
{
  options.dot.home.terminal = {
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
