{ ... }: {
  imports = [
    ../../modules/home-manager/im
    ../../modules/home-manager/neovim
    ../../modules/home-manager/zsh

    ../../modules/home-manager/desktop/theme.nix
    ../../modules/home-manager/dev.nix
    ../../modules/home-manager/direnv.nix
    ../../modules/home-manager/git.nix
    ../../modules/home-manager/kdewallet.nix
    ../../modules/home-manager/network.nix
  ];
}
