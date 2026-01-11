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
      browser.vivaldi.enable = true;
    };

    # Terminal
    terminal = {
      enable = true;
      ghostty.enable = true;
    };

    # Development
    dev = {
      enable = true;
      jetbrains.enable = true;
      mise.enable = true;
      ai = {
        enable = true;
        claude.enable = true;
        gemini.enable = true;
      };
    };

    # Apps
    apps.linux.hyprland.enable = true;

    # Other
    bitwarden.enable = true;
    network.enable = true;
    kdeconnect.enable = true;
    kdewallet.enable = true;
    obsidian.enable = true;
    ros2.enable = true;
    vr.enable = true;
  };

  home.file.".config/uwsm/env".text = ''
    export GBM_BACKEND=nvidia-drm
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
  '';
}
