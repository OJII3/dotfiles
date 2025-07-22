{ pkgs, ... }: {
  home.packages = with pkgs;
    [
      brightnessctl
      grim
      hyprpicker
      hyprpolkitagent
      libnotify
      networkmanagerapplet
      playerctl
      slurp
      tailscale-systray
      wl-clipboard
    ];

  wayland.windowManager.hyprland =
    {
      enable = true;
      systemd.enable = false; # for uwsm
      extraConfig = ''
        ${builtins.readFile ./devices.conf}
        ${builtins.readFile ./execs.conf}
        ${builtins.readFile ./general.conf}
        ${builtins.readFile ./keybinds.conf}
        ${builtins.readFile ./rules.conf}
        ${builtins.readFile ./plugins.conf}
      ''; # not load env, because it's loaded by uwsm
      plugins = [
        pkgs.hyprlandPlugins.hyprbars
      ];
    };
  home.file.".config/hypr/hyprland/scripts" = {
    source = ./scripts;
    recursive = true;
  };

  systemd.user.targets.hyprland-session = {
    Unit = {
      Description = "Hyprland compositor session";
      Documentation = [ "man:systemd.special(7)" ];
      BindsTo = [ "graphical-session.target" ];
      Wants = [ "graphical-session-pre.target" ];
      After = [ "graphical-session-pre.target" ];
    };
  };

  services.swayosd.enable = true;
}
