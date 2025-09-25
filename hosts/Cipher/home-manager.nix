{ ... }:
{
  imports = [
    ../../includes/home
    ../../includes/home/ai/codex
    ../../includes/home/apps/linux.nix
    ../../includes/home/cloudflare-warp.nix
    ../../includes/home/dev
    ../../includes/home/dev/mise.nix
    ../../includes/home/direnv.nix
    ../../includes/home/git
    ../../includes/home/im

    ../../includes/home/kdewallet.nix
    ../../includes/home/neovim
    ../../includes/home/network.nix
    ../../includes/home/sops.nix
    ../../includes/home/zsh

    ../../includes/home/server/kdeconnect.nix
    ../../includes/home/server/gpg.nix
  ];

  wayland.windowManager.hyprland.extraConfig = ''
    monitor=HDMI-A-2,1920x1080@60,auto,1
  '';
}
