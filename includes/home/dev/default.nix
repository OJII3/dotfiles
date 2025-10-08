{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nix-index
    comma

    # utilities
    bat
    bottom
    # httpie
    ripgrep
    yazi
    tmux
    imagemagick
    htop
    patchelf
    unzip
    zip
    unar
    tree
    zellij

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
