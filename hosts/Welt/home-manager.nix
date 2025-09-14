{ pkgs, ... }:
{
  imports = [
    ../../modules/home
    ../../modules/home/dev.nix
    ../../modules/home/direnv.nix
    ../../modules/home/git
    ../../modules/home/gpg/console.nix
    ../../modules/home/kdewallet.nix
    ../../modules/home/neovim
    ../../modules/home/network.nix
    ../../modules/home/zsh
  ];

  home.packages = with pkgs; [
    toybox
  ];
}
