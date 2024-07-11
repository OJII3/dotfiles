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

    # cli apps
    fastfetch
    termpdfpy
    byobu
    ollama

    # languages
    gcc
    cmake
    go
    rye 
    typst
  ];
}
    
