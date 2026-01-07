{ config, lib, pkgs, ... }:
let
  cfg = config.my.home.terminal;
in
{
  config = lib.mkIf cfg.ghostty.enable {
    programs.ghostty.enable = !pkgs.stdenv.isDarwin;
    home.file.".config/ghostty/config".source = ./config;
    home.packages = with pkgs; [
      udev-gothic-nf
    ];
  };
}
