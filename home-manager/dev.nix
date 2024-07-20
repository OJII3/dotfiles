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
    brightnessctl

    # cli apps
    fastfetch
    termpdfpy
    libsixel
    ollama
    online-judge-tools
    pdftk

    # sdk
    google-cloud-sdk
    terraform

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
    
