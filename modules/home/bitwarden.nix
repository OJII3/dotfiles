{ config, lib, pkgs, ... }:
let
  cfg = config.my.home;
in
{
  config = lib.mkIf cfg.bitwarden.enable {
    home.packages = with pkgs; [
      bitwarden-desktop
    ];
  };
}
