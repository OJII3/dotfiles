{ pkgs, ... }: {
  home.packages = with pkgs; [
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
    lzip
    tree
    zellij

    # cli apps
    claude-code
    fastfetch
    nyancat
    tdf
    # libsixel
    pdftk

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
    python3Full
    # rustup
    # typst
    # uv
  ];
}
    
