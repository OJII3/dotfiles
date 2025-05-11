{ ... }: {
  imports = [
    ../../modules/home
    ../../modules/home/dev.nix
    ../../modules/home/direnv.nix
    ../../modules/home/git
    ../../modules/home/gpg/console.nix
    ../../modules/home/sops.nix
    ../../modules/home/neovim
    ../../modules/home/network.nix
    ../../modules/home/terminal
    ../../modules/home/zsh
  ];
}
