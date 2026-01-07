# Desktop module options
# All option definitions for my.darwin.desktop.*
{ lib, ... }:
{
  options.my.darwin.desktop = {
    enable = lib.mkEnableOption "desktop environment configuration";

    apps = {
      enable = lib.mkEnableOption "Homebrew apps and casks";
    };

    vr = {
      enable = lib.mkEnableOption "VR development support (Meta XR Simulator)";
    };
  };
}
