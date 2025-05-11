{ ... }: {
  imports = [
    ../../modules/home
    ../../modules/home/desktop
    ../../modules/home/bitwarden.nix
    ../../modules/home/dev.nix
    ../../modules/home/cloudflare-warp.nix
    ../../modules/home/direnv.nix
    ../../modules/home/git
    ../../modules/home/gpg/linux-desktop.nix
    ../../modules/home/kdeconnect.nix
    ../../modules/home/kdewallet.nix
    ../../modules/home/neovim
    ../../modules/home/network.nix
    ../../modules/home/sops.nix
    ../../modules/home/terminal
    ../../modules/home/zsh
  ];
}
