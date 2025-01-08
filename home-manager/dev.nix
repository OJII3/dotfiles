{ pkgs, ... }: {
  home.packages = with pkgs; [
    # utilities
    bat
    bottom
    httpie
    ripgrep
    fzf
    yazi
    tmux
    imagemagick
    htop
    patchelf
    unzip
    zip
    unar
    lzip
    wev
    ocs-url
    tree

    # cli apps
    fastfetch
    nyancat
    tdf
    libsixel
    online-judge-tools
    pdftk

    # sdk, toolchain
    google-cloud-sdk
    google-cloud-sql-proxy
    terraform

    # languages
    gcc
    cmake
    meson
    gnumake
    go
    rye
    typst
    dotnet-sdk
    rustup
    python311
    mise
    bun
    ghc
    R
  ];
}
    
