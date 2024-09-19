{ pkgs, ... }: {
  home = rec {
    username = "ojii3";
    homeDirectory = "/home/${username}";
    stateVersion = "24.11";
  };
  programs.home-manager.enable = true;
  imports = [
    ./git.nix
    ./neovim.nix
    ./dev.nix
    ./browser.nix
    ./direnv.nix
    ./apps.nix
    ./desktop.nix
    ./zsh.nix
    ./fcitx.nix
    ./terminal.nix
    ./network.nix
  ];
}
