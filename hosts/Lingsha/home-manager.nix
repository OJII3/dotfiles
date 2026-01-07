{ ... }:
{
  imports = [
    ../../modules/home
    ../../modules/home/apps/linux/common.nix
    ../../modules/home/bitwarden.nix
    ../../modules/home/desktop/theme.nix
    ../../modules/home/desktop/keyd
    ../../modules/home/dev
    ../../modules/home/dev/ai/codex
    ../../modules/home/dev/ai/gemini
    ../../modules/home/dev/mise.nix
    ../../modules/home/direnv.nix
    ../../modules/home/git
    ../../modules/home/gpg/linux-desktop.nix
    ../../modules/home/desktop/fcitx5
    ../../modules/home/neovim
    ../../modules/home/network.nix
    ../../modules/home/sops.nix
    ../../modules/home/terminal/ghostty
    ../../modules/home/zsh
  ];

  targets.genericLinux.enable = true;
}
