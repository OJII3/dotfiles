{ inputs, pkgs, ... }: {
  imports = [
    ../../modules/home/git
    ../../modules/home/im
    ../../modules/home/neovim
    ../../modules/home/terminal
    ../../modules/home/desktop
    ../../modules/home/zsh

    ../../modules/home/apps.nix
    ../../modules/home/assets.nix
    ../../modules/home/browser.nix
    ../../modules/home/dev.nix
    ../../modules/home/direnv.nix
    ../../modules/home/kdewallet.nix
    ../../modules/home/network.nix
  ];

  # laptop specific config
  wayland.windowManager.hyprland.extraConfig = ''
    exec-once = hypridle
  '';
}
