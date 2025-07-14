{ ... }: {
  imports = [
    ../../modules/home
    ../../modules/home/apps.nix
    ../../modules/home/bitwarden.nix
    ../../modules/home/browser.nix
    ../../modules/home/desktop/hyprland.nix
    ../../modules/home/desktop/theme.nix
    ../../modules/home/dev
    ../../modules/home/dev/mise.nix
    ../../modules/home/direnv.nix
    ../../modules/home/git
    ../../modules/home/gpg/linux-desktop.nix
    ../../modules/home/im
    ../../modules/home/kdeconnect.nix
    ../../modules/home/kdewallet.nix
    ../../modules/home/neovim
    ../../modules/home/network.nix
    ../../modules/home/sops.nix
    ../../modules/home/terminal
    ../../modules/home/unityhub.nix
    ../../modules/home/zsh
  ];

  wayland.windowManager.hyprland.extraConfig = ''
    exec-once = wayvnc 0.0.0.0
    exec-once = sunshine
  '';

  home.file.".config/uwsm/env".text = ''
    export GBM_BACKEND=nvidia-drm
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    # export LIBVA_DRIVER_NAME=nvidia
  '';
}

