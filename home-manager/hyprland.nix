{ inputs, pkgs, ... }: {
  home.packages = with pkgs;
    [
      hyprpaper
      hypridle
      hyprlock
      hyprpicker
      # hyprpanel
      # inputs.hyprland-plugins.packages.${pkgs.system}.hyprexpo
      inputs.hyprpolkitagent.packages.${pkgs.system}.hyprpolkitagent
      # canta-theme # set below
      anyrun
      waybar
      wlogout
      libnotify
      brightnessctl
      grim
      slurp
      playerctl
      wl-clipboard
      networkmanagerapplet
      kdePackages.plasma-workspace # xembedsniproxy
    ];

  # programs.waybar = {
  #   enable = true;
  # };

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
  home.file.".config/waybar" = {
    source = ../home/.config/waybar;
    recursive = true;
  };
  home.file.".config/wlogout" = {
    source = ../home/.config/wlogout;
    recursive = true;
  };
  # home.file.".config/gtk-3.0" = {
  #   source = ../home/.config/gtk-3.0;
  #   recursive = true;
  # };
  # home.file.".config/gtk-4.0" = {
  #   source = ../home/.config/gtk-4.0;
  #   recursive = true;
  # };

  gtk = {
    enable = true;
    theme = {
      package = pkgs.canta-theme;
      name = "Canta";
    };
  };
}

