{ ... }: {
  imports = [
    ../../modules/home
    ../../modules/home/ai/claude.nix
    ../../modules/home/apps.nix
    ../../modules/home/bitwarden.nix
    ../../modules/home/browser.nix
    ../../modules/home/cloudflare-warp.nix
    ../../modules/home/desktop
    ../../modules/home/dev.nix
    ../../modules/home/direnv.nix
    ../../modules/home/git
    ../../modules/home/gpg/linux-desktop.nix
    ../../modules/home/kdeconnect.nix
    ../../modules/home/kdewallet.nix
    ../../modules/home/neovim
    ../../modules/home/im
    ../../modules/home/network.nix
    ../../modules/home/sops.nix
    ../../modules/home/terminal
    ../../modules/home/zsh
  ];

  wayland.windowManager.hyprland.extraConfig = ''
    monitor=HDMI-A-2,1920x1080@60,auto,1
    $mod = ALT_L
  '';
}
