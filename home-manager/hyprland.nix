{ inputs, pkgs, ... }: {
  wayland.windowManager.hyprland =
    {
      enable = true;
      systemd.variables = [ "--all" ];
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      extraConfig = ''
        ${builtins.readFile ../home/.config/hypr/hyprland/env.conf}
        ${builtins.readFile ../home/.config/hypr/hyprland/devices.conf}
        ${builtins.readFile ../home/.config/hypr/hyprland/execs.conf}
        ${builtins.readFile ../home/.config/hypr/hyprland/general.conf}
        ${builtins.readFile ../home/.config/hypr/hyprland/keybinds.conf}
        ${builtins.readFile ../home/.config/hypr/hyprland/rules.conf}
      '';
      plugins = [
        # inputs.hyprland-plugins.packages.${pkgs.system}.hyprexpo
        # inputs.hyprland-plugins.packages.${pkgs.system}.hyprbars
      ];
    };

  home.packages = with pkgs;
    [
      hyprpaper
      hypridle
      hyprlock
      hyprpicker
      hyprpanel
      # inputs.hyprland-plugins.packages.${pkgs.system}.hyprexpo
      inputs.hyprpolkitagent.packages.${pkgs.system}.hyprpolkitagent
      canta-theme
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
      # kwallet
      libsForQt5.kwallet
      libsForQt5.kwallet-pam
      libsForQt5.kwalletmanager
      libsForQt5.ksshaskpass
    ];
  # programs.waybar = {
  #   enable = true;
  # };

  home.file.".config/kwalletrc".text = ''
    [Wallet]
    Default Wallet=kdewallet
    First Use=false

    [org.freedesktop.secrets]
    apiEnabled=true
    autoStart=true
  '';

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
  home.file.".config/gtk-3.0" = {
    source = ../home/.config/gtk-3.0;
    recursive = true;
  };
  home.file.".config/gtk-4.0" = {
    source = ../home/.config/gtk-4.0;
    recursive = true;
  };
}

