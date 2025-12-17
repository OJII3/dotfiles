{ pkgs, ... }:
{
  imports = [ ../default.nix ];
  programs.ghostty.enable = !pkgs.stdenv.isDarwin;
  home.file.".config/ghostty/config".source = ./config;
  home.packages = with pkgs; [
    udev-gothic-nf
  ];
}
