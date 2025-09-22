{ ... }:
{
  imports = [
    ../../modules/home
    ../../modules/home/ai/codex
    ../../modules/home/apps/linux.nix
    ../../modules/home/cloudflare-warp.nix
    ../../modules/home/dev
    ../../modules/home/dev/mise.nix
    ../../modules/home/direnv.nix
    ../../modules/home/git
    ../../modules/home/im

    ../../modules/home/kdewallet.nix
    ../../modules/home/neovim
    ../../modules/home/network.nix
    ../../modules/home/sops.nix
    ../../modules/home/zsh

    ../../modules/home/server/kdeconnect.nix
    ../../modules/home/server/gpg.nix
  ];

  wayland.windowManager.hyprland.extraConfig = ''
    monitor=HDMI-A-2,1920x1080@60,auto,1
  '';
}
