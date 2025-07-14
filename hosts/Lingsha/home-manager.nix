{ ... }: {
  imports = [
    ../../modules/home
    ../../modules/home/ai/claude.nix
    ../../modules/home/apps.nix
    ../../modules/home/bitwarden.nix
    ../../modules/home/browser.nix
    ../../modules/home/cloudflare-warp.nix
    ../../modules/home/desktop
    ../../modules/home/dev
    ../../modules/home/dev/mise.nix
    ../../modules/home/direnv.nix
    ../../modules/home/git
    ../../modules/home/gpg/linux-desktop.nix
    ../../modules/home/im
    ../../modules/home/kdewallet.nix
    ../../modules/home/neovim
    ../../modules/home/network.nix
    ../../modules/home/sops.nix
    ../../modules/home/terminal
    ../../modules/home/unityhub.nix
    ../../modules/home/zsh
  ];

  # laptop specific config
  wayland.windowManager.hyprland.extraConfig = ''
    exec-once = hypridle
  '';
}
