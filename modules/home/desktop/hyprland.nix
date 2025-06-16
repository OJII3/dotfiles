{ pkgs, ... }: {
  home.packages = with pkgs;
    [
      anyrun
      brightnessctl
      grim
      hypridle
      hyprlock
      hyprpaper
      hyprpicker
      hyprpolkitagent
      libnotify
      networkmanagerapplet
      overskride
      playerctl
      slurp
      swaynotificationcenter
      wl-clipboard
      wlogout
    ];

  wayland.windowManager.hyprland =
    {
      enable = true;
      systemd.enable = false; # for uwsm
      extraConfig = ''
        ${builtins.readFile ./config/hypr/hyprland/devices.conf}
        ${builtins.readFile ./config/hypr/hyprland/execs.conf}
        ${builtins.readFile ./config/hypr/hyprland/general.conf}
        ${builtins.readFile ./config/hypr/hyprland/keybinds.conf}
        ${builtins.readFile ./config/hypr/hyprland/rules.conf}
      ''; # not load env, because it's loaded by uwsm
      plugins = [
        # pkgs.hyprlandPlugins.hyprbars
      ];
    };

  home.file.".config/uwsm/env".source = config/uwsm/env;
  # home.file."config/uwsm/env-hyprland".source = config/uwsm/env-hyprland;
  home.file.".config/hypr/hyprlock.conf".source = ./config/hypr/hyprlock.conf;
  home.file.".config/hypr/hypridle.conf".source = ./config/hypr/hypridle.conf;
  home.file.".config/hypr/hyprpaper.conf".source = ./config/hypr/hyprpaper.conf;
  home.file.".config/hypr/hyprland/scripts" = {
    source = ./config/hypr/hyprland/scripts;
    recursive = true;
  };

  # launcher
  home.file.".config/anyrun" = {
    source = ./config/anyrun;
    recursive = true;
  };

  # status bar
  programs.waybar = {
    enable = true;
  };
  home.file.".config/waybar" = {
    source = ./config/waybar;
    recursive = true;
  };

  # Power management
  home.file.".config/wlogout" = {
    source = ./config/wlogout;
    recursive = true;
  };

  # notification
  services.swaync = {
    enable = true;
  };

  xdg.portal.enable = true;
  # xdg.portal.extraPortals = with pkgs; [
  #   xdg-desktop-portal-gtk
  # ];
}

