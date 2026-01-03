{ ... }:
{
  imports = [
    ../../includes/home
    ../../includes/home/apps/linux/common.nix
    ../../includes/home/bitwarden.nix
    ../../includes/home/desktop/browser/vivaldi
    ../../includes/home/desktop/fcitx5
    ../../includes/home/desktop/keyd
    ../../includes/home/desktop/theme.nix
    ../../includes/home/dev
    ../../includes/home/dev/ai/codex
    ../../includes/home/dev/ai/gemini
    ../../includes/home/dev/jetbrains
    ../../includes/home/dev/mise.nix
    ../../includes/home/direnv.nix
    ../../includes/home/git
    ../../includes/home/gpg/linux-desktop.nix
    ../../includes/home/neovim
    ../../includes/home/network.nix
    ../../includes/home/sops.nix
    ../../includes/home/terminal/ghostty
    ../../includes/home/zsh
  ];

  targets.genericLinux = {
    enable = true;
    gpu = {
      enable = true;
    };
  };
}
