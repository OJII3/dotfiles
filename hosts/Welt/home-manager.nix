{ pkgs, ... }:
{
  imports = [
    ../../includes/home
    ../../includes/home/dev.nix
    ../../includes/home/direnv.nix
    ../../includes/home/git
    ../../includes/home/gpg/console.nix
    ../../includes/home/kdewallet.nix
    ../../includes/home/neovim
    ../../includes/home/network.nix
    ../../includes/home/zsh
  ];

  home.packages = with pkgs; [
    toybox
  ];
}
