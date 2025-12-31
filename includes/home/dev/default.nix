{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nix-index
    comma

    # utilities
    bat
    bottom
    fastfetch
    fd
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
    # television

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

  programs.television = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      ui = {
        use_nerd_font_icons = true;
      };
    };
  };
  programs.nix-search-tv = {
    enable = true;
    enableTelevisionIntegration = true;
    settings = {
      indexes = [
        "nixpkgs"
        "home-manager"
        "nixos"
      ];

      experimental = {
        render_docs_indexes = {
          nvf = "https://notashelf.github.io/nvf/options.html";
        };
      };
    };
  };
}
