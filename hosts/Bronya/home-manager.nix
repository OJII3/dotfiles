{ ... }:
{
  imports = [
    ../../includes/home
    ../../includes/home/apps/linux.nix
    ../../includes/home/bitwarden.nix
    ../../includes/home/desktop
    ../../includes/home/desktop/hyprland/default-monitors.nix
    ../../includes/home/dev
    ../../includes/home/dev/mise.nix
    ../../includes/home/direnv.nix
    ../../includes/home/git
    ../../includes/home/gpg/linux-desktop.nix
    ../../includes/home/im
    ../../includes/home/kdeconnect.nix
    ../../includes/home/kdewallet.nix
    ../../includes/home/neovim
    ../../includes/home/network.nix
    ../../includes/home/sops.nix
    ../../includes/home/terminal/kitty
    ../../includes/home/unityhub.nix
    ../../includes/home/vr.nix
    ../../includes/home/zsh
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
