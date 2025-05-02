{ ... }: {
  imports = [
    ../../modules/home
    ../../modules/home/neovim
    ../../modules/home/zsh
    ../../modules/home/gpg/linux-console.nix

    ../../modules/home/dev.nix
    ../../modules/home/direnv.nix
    ../../modules/home/git
    ../../modules/home/kdewallet.nix
    ../../modules/home/network.nix
  ];
}
