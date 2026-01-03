{ ... }:
{
  imports = [
    ../../includes/home
    ../../includes/home/apps/linux/gnome.nix
    ../../includes/home/bitwarden.nix
    ../../includes/home/desktop/browser/vivaldi
    ../../includes/home/desktop/fcitx5
    ../../includes/home/desktop/gnome
    ../../includes/home/desktop/keyd
    ../../includes/home/desktop/theme.nix
    ../../includes/home/dev
    ../../includes/home/dev/ai/claude
    ../../includes/home/dev/ai/codex
    ../../includes/home/dev/ai/gemini
    ../../includes/home/dev/jetbrains
    ../../includes/home/dev/mise.nix
    ../../includes/home/dev/vscode
    ../../includes/home/direnv.nix
    ../../includes/home/git
    ../../includes/home/neovim
    ../../includes/home/network.nix
    ../../includes/home/ros2 # ros2
    ../../includes/home/sops.nix
    ../../includes/home/terminal/ghostty
    ../../includes/home/zsh
  ];
}
