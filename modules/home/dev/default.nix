# Home Manager Dev modules
# Development tools configuration with customizable options.
#
# Options are defined in ./options.nix
#
{ config, lib, pkgs, ... }:
let
  cfg = config.dot.home.dev;
in
{
  imports = [
    ./options.nix
    ./jetbrains
    ./mise.nix
    ./vscode
    ./zellij
  ];

  # Base dev configuration
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      nix-index
      comma

      # utilities
      bat
      btop
      fastfetch
      fd
      ffmpeg
      htop
      imagemagick
      patchelf
      ripgrep
      tmux
      tree
      unar
      unzip
      yazi
      zip
      ni

      # cli apps
      tdf

      # languages
      cmake
    ];
  };
}
