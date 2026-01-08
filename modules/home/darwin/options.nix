# Darwin module options
# All option definitions for dot.home.darwin.*
{ lib, ... }:
{
  options.dot.home.darwin = {
    aerospace = {
      enable = lib.mkEnableOption "Aerospace window manager";
    };

    jankyborders = {
      enable = lib.mkEnableOption "JankyBorders window borders";
    };

    apps = {
      enable = lib.mkEnableOption "Common macOS applications";
    };
  };
}
