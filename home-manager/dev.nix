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
    gnupg
    ldm
    udisks2

    # cli apps
    fastfetch
    termpdfpy
    libsixel
    byobu
    ollama
    online-judge-tools
    pdftk

    # languages
    gcc
    cmake
    go
    rye
    typst
    dotnet-sdk
    rustup
    python312
  ];
}
    
