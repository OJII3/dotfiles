{ pkgs, ... }: {
  imports = [
    ../../home-manager/apps.nix
    ../../home-manager/browser.nix
    ../../home-manager/dev.nix
    ../../home-manager/direnv.nix
    ../../home-manager/fcitx.nix
    ../../home-manager/git.nix
    ../../home-manager/hyprland.nix
    ../../home-manager/kdewallet.nix
    ../../home-manager/neovim.nix
    ../../home-manager/network.nix
    ../../home-manager/plasma.nix
    ../../home-manager/terminal.nix
    ../../home-manager/zsh.nix
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

