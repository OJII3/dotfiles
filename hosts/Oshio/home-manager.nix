{ ... }: {
  imports = [
    ../../modules/home/im
    ../../modules/home/neovim
    ../../modules/home/zsh

    ../../modules/home/desktop/theme.nix
    ../../modules/home/dev.nix
    ../../modules/home/direnv.nix
    ../../modules/home/git.nix
    ../../modules/home/kdewallet.nix
    ../../modules/home/network.nix
  ];
}
