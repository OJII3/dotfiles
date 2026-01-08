# Darwin module options
# All option definitions for my.home.darwin.*
{ lib, ... }:
{
  options.my.home.darwin = {
    aerospace = {
      enable = lib.mkEnableOption "Aerospace window manager";
    };

    jankyborders = {
      enable = lib.mkEnableOption "JankyBorders window borders";
    };

    skhd = {
      enable = lib.mkEnableOption "skhd hotkey daemon";
    };
  };
}
