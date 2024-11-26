{ inputs, pkgs, ... }: {
  wayland.windowManager.hyprland =
    {
      enable = true;
      systemd.enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      extraConfig = builtins.readFile ../home/.config/hypr/hyprland.conf;
      plugins = [
        # inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprexpo
        # inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprbars
      ];
    };

  home.packages = with pkgs;
    [
      hyprpaper
      hypridle
      hyprlock
      hyprpicker
      inputs.hyprland-plugins.packages.${pkgs.system}.hyprexpo
      anyrun
      waybar
      wlogout
      libnotify
      grim
      slurp
      playerctl
      wl-clipboard
      networkmanagerapplet
      swaynotificationcenter
      kdePackages.plasma-workspace
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

  home.file.".config/hypr" = {
    source = ../home/.config/hypr;
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
  home.file.".config/swaync" = {
    source = ../home/.config/swaync;
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

  wayland.windowManager.hyprland.systemd.variables = [ "--all" ];
}

