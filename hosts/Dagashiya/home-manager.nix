{ inputs, pkgs, ... }: {
  imports = [
    ../../modules/home-manager/apps
    ../../modules/home-manager/neovim

    ../../modules/home-manager/assets.nix
    ../../modules/home-manager/browser.nix
    ../../modules/home-manager/dev.nix
    ../../modules/home-manager/direnv.nix
    ../../modules/home-manager/git.nix
    ../../modules/home-manager/terminal/config.nix
    ../../modules/home-manager/zsh.nix
  ];

  programs.kitty.enable = true;
  programs.gpg = {
    enable = true;
  };
}
