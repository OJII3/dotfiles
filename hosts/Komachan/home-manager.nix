{ inputs, pkgs, ... }: {
  imports = [
    ../../modules/home-manager/git
    ../../modules/home-manager/im
    ../../modules/home-manager/neovim
    ../../modules/home-manager/terminal
    ../../modules/home-manager/desktop
    ../../modules/home-manager/zsh

    ../../modules/home-manager/apps.nix
    ../../modules/home-manager/assets.nix
    ../../modules/home-manager/browser.nix
    ../../modules/home-manager/dev.nix
    ../../modules/home-manager/direnv.nix
    ../../modules/home-manager/kdewallet.nix
    ../../modules/home-manager/network.nix
  ];

  # laptop specific config
  wayland.windowManager.hyprland.extraConfig = ''
    exec-once = hypridle
  '';
}
