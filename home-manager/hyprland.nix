{ inputs, pkgs, ... }: {
  home.packages = with pkgs;
    [
      hyprpaper
      hypridle
      hyprlock
      hyprpicker
      inputs.hyprpolkitagent.packages.${pkgs.system}.hyprpolkitagent
      anyrun
      brightnessctl
      grim
      kdePackages.plasma-workspace # xembedsniproxy
      networkmanagerapplet
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
      package = inputs.hyprland.packages.${pkgs.system}.hyprland; # not from homa-manager, but from flakes
      extraConfig = ''
        ${builtins.readFile ../home/.config/hypr/hyprland/devices.conf}
        ${builtins.readFile ../home/.config/hypr/hyprland/execs.conf}
        ${builtins.readFile ../home/.config/hypr/hyprland/general.conf}
        ${builtins.readFile ../home/.config/hypr/hyprland/keybinds.conf}
        ${builtins.readFile ../home/.config/hypr/hyprland/rules.conf}
      ''; # not load env, because it's loaded by uwsm
      plugins = [
        inputs.hyprland-plugins.packages.${pkgs.system}.hyprexpo
      ];
    };



  home.file.".config/uwsm/env".source = ../home/.config/uwsm/env;
  # home.file.".config/uwsm/env-hyprland".source = ../home/.config/uwsm/env-hyprland;
  home.file.".config/hypr/hyprlock.conf".source = ../home/.config/hypr/hyprlock.conf;
  home.file.".config/hypr/hypridle.conf".source = ../home/.config/hypr/hypridle.conf;
  home.file.".config/hypr/hyprpaper.conf".source = ../home/.config/hypr/hyprpaper.conf;
  home.file.".config/hypr/hyprland/scripts" = {
    source = ../home/.config/hypr/hyprland/scripts;
    recursive = true;
  };

  home.file.".config/anyrun" = {
    source = ../home/.config/anyrun;
    recursive = true;
  };

  # status bar
  programs.waybar = {
    enable = true;
    systemd.enable = true;
  };
  home.file.".config/waybar" = {
    source = ../home/.config/waybar;
    recursive = true;
  };

  # notification
  home.file.".config/wlogout" = {
    source = ../home/.config/wlogout;
    recursive = true;
  };
  services.swaync = {
    enable = true;
  };

  services.network-manager-applet.enable = true;

  gtk = {
    enable = true;
    theme = {
      package = pkgs.canta-theme;
      name = "Canta-dark";
    };
  };
}

