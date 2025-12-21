{ ... }:
{
  imports = [
    ../../includes/home
    ../../includes/home/apps/linux/common.nix
    ../../includes/home/bitwarden.nix
    ../../includes/home/desktop/gnome
    ../../includes/home/desktop/keyd
    ../../includes/home/desktop/theme.nix
    ../../includes/home/dev
    ../../includes/home/dev/ai/claude
    ../../includes/home/dev/ai/codex
    ../../includes/home/dev/ai/gemini
    ../../includes/home/dev/mise.nix
    ../../includes/home/direnv.nix
    ../../includes/home/git
    ../../includes/home/helix.nix
    ../../includes/home/im
    ../../includes/home/neovim
    ../../includes/home/network.nix
    ../../includes/home/ros2 # ros2
    ../../includes/home/sops.nix
    ../../includes/home/terminal/ghostty
    ../../includes/home/zsh
  ];
}
