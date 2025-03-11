{ pkgs, ... }: {
  imports = [
    ../../modules/home/git
    ../../modules/home/im
    ../../modules/home/neovim
    ../../modules/home/terminal
    ../../modules/home/zsh

    ../../modules/home/apps.nix
    ../../modules/home/assets.nix
    ../../modules/home/browser.nix
    ../../modules/home/dev.nix
    ../../modules/home/direnv.nix
    ../../modules/home/desktop/hyprland.nix
    ../../modules/home/desktop/theme.nix
    ../../modules/home/kdewallet.nix
    ../../modules/home/network.nix
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

