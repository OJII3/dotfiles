{ ... }:
{
  imports = [
    ../../modules/home
  ];

  dot.home = {
    # Shell & Editor
    zsh.enable = true;
    neovim.enable = true;
    git.enable = true;
    gpg = {
      enable = true;
      pinentryPackage = "qt";
    };
    direnv.enable = true;
    sops.enable = true;

    # Desktop
    desktop = {
      enable = true;
      hyprland.enable = true;
      waybar.enable = true;
      anyrun.enable = true;
      swaync.enable = true;
      wlogout.enable = true;
      fcitx5.enable = true;
      theme.enable = true;
    };

    # Terminal
    terminal = {
      enable = true;
      kitty.enable = true;
    };

    # Development
    dev = {
      enable = true;
      mise.enable = true;
    };

    # Apps
    apps.linux.hyprland.enable = true;

    # Other
    bitwarden.enable = true;
    network.enable = true;
    kdeconnect.enable = true;
    kdewallet.enable = true;
    vr.enable = true;
  };

  # Host-specific Hyprland config
  wayland.windowManager.hyprland.extraConfig = ''
    exec-once = wayvnc 0.0.0.0
    exec-once = sunshine
  '';

  home.file.".config/uwsm/env".text = ''
    export GBM_BACKEND=nvidia-drm
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
  '';
}
