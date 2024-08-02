{ pkgs, ... }: {
  home.packages = with pkgs; [
    # utilities
    bat
    bottom
    httpie
    ripgrep
    pingu
    fzf
    tig
    delta
    yazi
    tmux
    imagemagick
    htop
    patchelf
    unzip
    zip
    unar
    lzip
    gnupg
    brightnessctl
    wev

    # cli apps
    fastfetch
    termpdfpy
    libsixel
    ollama
    online-judge-tools
    pdftk

    # sdk, toolchain
    google-cloud-sdk
    google-cloud-sql-proxy
    terraform
    mdbook

    # languages
    gcc
    cmake
    gnumake
    go
    rye
    typst
    dotnet-sdk
    rustup
    python311
    mise
    bun
  ];
}
    
