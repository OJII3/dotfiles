{ pkgs, ... }: {
  imports = [
    ../../home-manager/apps.nix
    ../../home-manager/browser.nix
    # ../../home-manager/hyprland.nix
    ../../home-manager/plasma.nix
    ../../home-manager/dev.nix
    ../../home-manager/direnv.nix
    ../../home-manager/fcitx.nix
    ../../home-manager/git.nix
    ../../home-manager/neovim.nix
    ../../home-manager/network.nix
    ../../home-manager/terminal.nix
    ../../home-manager/zsh.nix
  ];

  programs.plasma = {
    configFile = {
      "kscreenlockerrc"."Daemon"."Autolock" = false;
      "kscreenlockerrc"."Daemon"."Timeout" = 0;
    };
  };
    # wayland.windowManager.hyprland.extraConfig = ''
    #   env = GBM_BACKEND,nvidia-drm
    #   env = __GLX_VENDOR_LIBRARY_NAME,nvidia
    #   # env = LIBVA_DRIVER_NAME,nvidia
    #
    #   exec-once = wayvnc 0.0.0.0
    # '';
    }

