# Bitwarden desktop password manager
{ config, lib, pkgs, ... }:
let
  cfg = config.dot.desktop;
in
{
  config = lib.mkIf (cfg.enable && cfg.bitwarden.enable) {
    environment.systemPackages = [ pkgs.bitwarden-desktop ];
  };
}
