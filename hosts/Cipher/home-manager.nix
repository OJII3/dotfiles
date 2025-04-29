{ ... }: {
  imports = [
    ../../modules/home
    ../../modules/home/git
    ../../modules/home/neovim
    ../../modules/home/terminal
    ../../modules/home/zsh

    ../../modules/home/dev.nix
    ../../modules/home/direnv.nix
    ../../modules/home/kdewallet.nix
    ../../modules/home/network.nix
  ];
}
