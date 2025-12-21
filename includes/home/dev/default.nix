{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nix-index
    comma

    # utilities
    bat
    bottom
    fastfetch
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
    zellij
    zip
    ni

    # cli apps
    tdf

    # sdk, toolchain
    # google-cloud-sdk
    # google-cloud-sql-proxy
    # terraform

    # languages
    cmake
    # dotnet-sdk
    # gcc
    # gnumake
    # go
    # meson
    python312
  ];
}
