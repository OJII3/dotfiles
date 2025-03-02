{ pkgs, ... }: {
  imports = [
    ../../modules/home-manager/git
    ../../modules/home-manager/im
    ../../modules/home-manager/neovim
    ../../modules/home-manager/terminal
    ../../modules/home-manager/zsh

    ../../modules/home-manager/apps.nix
    ../../modules/home-manager/assets.nix
    ../../modules/home-manager/browser.nix
    ../../modules/home-manager/dev.nix
    ../../modules/home-manager/direnv.nix
    ../../modules/home-manager/desktop/hyprland.nix
    ../../modules/home-manager/desktop/theme.nix
    ../../modules/home-manager/kdewallet.nix
    ../../modules/home-manager/network.nix
    ../../modules/home-manager/plasma.nix
  ];

  wayland.windowManager.hyprland.extraConfig = ''
    exec-once = wayvnc 0.0.0.0
  '';

  home.file.".config/uwsm/env".text = ''
    export GBM_BACKEND=nvidia-drm
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    # export LIBVA_DRIVER_NAME=nvidia
  '';
}

