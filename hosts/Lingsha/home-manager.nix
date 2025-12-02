{ ... }:
{
  imports = [
    ../../includes/home
    ../../includes/home/ai/codex
    # ../../includes/home/apps/linux.nix
    ../../includes/home/bitwarden.nix
    ../../includes/home/cloudflare-warp.nix
    ../../includes/home/desktop/theme.nix
    # ../../includes/home/desktop/hyprland/default-monitors.nix
    ../../includes/home/dev
    ../../includes/home/dev/mise.nix
    ../../includes/home/direnv.nix
    ../../includes/home/git
    ../../includes/home/gpg/linux-desktop.nix
    ../../includes/home/im
    # ../../includes/home/kdewallet.nix
    ../../includes/home/neovim
    ../../includes/home/network.nix
    ../../includes/home/sops.nix
    # ../../includes/home/terminal/kitty
    # ../../includes/home/unityhub.nix
    ../../includes/home/zsh
  ];

  # services.hypridle.enable = true;
  targets.genericLinux.enable = true;

  home.file.".config/ghostty" = {
    source = ./.;
    recursive = true;
  };
}
