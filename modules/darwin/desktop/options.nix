# Desktop module options
# All option definitions for dot.darwin.desktop.*
{ lib, ... }:
{
  options.dot.darwin.desktop = {
    enable = lib.mkEnableOption "desktop environment configuration";

    apps = {
      enable = lib.mkEnableOption "Homebrew apps and casks";
    };

    vr = {
      enable = lib.mkEnableOption "VR development support (Meta XR Simulator)";
    };
  };
}
