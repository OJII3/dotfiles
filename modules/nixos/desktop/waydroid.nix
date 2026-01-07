# Waydroid Android container configuration
{ config, lib, pkgs, ... }:
let
  cfg = config.my.desktop;
in
{
  config = lib.mkIf (cfg.enable && cfg.waydroid.enable) {
    environment.systemPackages = [ pkgs.waydroid-helper ];
    virtualisation.waydroid.enable = true;
  };
}
