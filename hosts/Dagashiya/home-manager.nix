{ pkgs, pkgs-stable, ... }: {
  imports = [
    ../../modules/home-manager/apps
    ../../modules/home-manager/git
    ../../modules/home-manager/neovim
    ../../modules/home-manager/terminal/config.nix
    ../../modules/home-manager/zsh

    ../../modules/home-manager/assets.nix
    ../../modules/home-manager/browser.nix
    ../../modules/home-manager/dev.nix
    ../../modules/home-manager/direnv.nix
  ];

  programs.kitty.enable = true;
  programs.gpg = {
    enable = true;
  };
}
