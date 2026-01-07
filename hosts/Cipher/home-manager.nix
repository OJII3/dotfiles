{ ... }:
{
  imports = [
    ../../modules/home
    ../../modules/home/dev
    ../../modules/home/dev/ai/claude
    ../../modules/home/dev/ai/codex
    ../../modules/home/dev/mise.nix
    ../../modules/home/dev/vscode
    ../../modules/home/direnv.nix
    ../../modules/home/git
    ../../modules/home/gnome-keyring.nix
    ../../modules/home/neovim
    ../../modules/home/network.nix
    ../../modules/home/server/gpg.nix
    ../../modules/home/server/kdeconnect.nix
    ../../modules/home/sops.nix
    ../../modules/home/terminal/ghostty
    ../../modules/home/zsh
  ];
}
