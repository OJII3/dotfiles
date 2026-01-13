{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dot.home.desktop;
in
{
  config = lib.mkIf cfg.hyprland.enable {
    home.packages = with pkgs; [
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
      rose-pine-hyprcursor
    ];

    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = false; # for uwsm
      extraConfig = ''
        ${builtins.readFile ./devices.conf}
        ${builtins.readFile ./execs.conf}
        ${builtins.readFile ./general.conf}
        ${builtins.readFile ./keybinds.conf}
        ${builtins.readFile ./rules.conf}
        ${builtins.readFile ./plugins.conf}
      '';
      plugins = [
        pkgs.hyprlandPlugins.hyprbars
      ];
    };
    home.file.".config/hypr/hyprland/scripts" = {
      source = ./scripts;
      recursive = true;
    };

    services = {
      hyprpolkitagent.enable = true;
      hyprlauncher = {
        enable = true;
        settings = {

        };
      };
    };
    systemd.user.services.hyprpolkitagent = {
      Unit.After = [ "graphical-session.target" ];
      Install.WantedBy = [ "graphical-session.target" ];
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
    xdg.portal.enable = true;
  };
}
