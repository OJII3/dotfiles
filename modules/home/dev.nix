{ pkgs, ... }: {
  home.packages = with pkgs; [
    # utilities
    bat
    bottom
    byobu
    httpie
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

    # cli apps
    fastfetch
    nyancat
    tdf
    libsixel
    online-judge-tools
    pdftk

    # sdk, toolchain
    # google-cloud-sdk
    # google-cloud-sql-proxy
    # terraform

    # languages
    bun
    cmake
    # dotnet-sdk
    # gcc
    # gnumake
    go
    # meson
    mise
    python311
    # rustup
    # typst
    # uv
  ];
}
    
