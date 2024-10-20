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
    brightnessctl
    wev
    ocs-url
    tree

    # cli apps
    fastfetch
    nyancat
    # termpdfpy # <- broken
    libsixel
    libwebp
    ollama
    online-judge-tools
    pdftk
    python312Packages.huggingface-hub

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
    ghc
  ];
}
    
