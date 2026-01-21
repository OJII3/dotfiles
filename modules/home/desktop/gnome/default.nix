{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.dot.home.desktop;
in
{
  config = lib.mkIf cfg.gnome.enable {
    home.packages = with pkgs; [
      gnome-randr
    ];

    xdg.autostart.enable = true;
    xdg.enable = true;
    programs.gnome-shell = {
      enable = true;
      extensions =
        let
          ext = pkgs.gnomeExtensions;
        in
        [
          { package = ext.appindicator; }
          { package = ext.blur-my-shell; }
          { package = ext.caffeine; }
          { package = ext.gsconnect; }
          { package = ext.kimpanel; }
          { package = ext.tailscale-status; }
          { package = ext.color-picker; }
          { package = ext.vicinae; }
          { package = inputs.confetti.packages.${pkgs.stdenv.hostPlatform.system}.gnome-extension; }
        ];
    };

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        clock-show-weekday = true;
      };
      "org/gnome/desktop/background" = {
        picture-uri = "file:///home/ojii3/.assets/images/honkai3rd_efcs.png";
        picture-uri-dark = "file:///home/ojii3/.assets/images/honkai3rd_efcs.png";
        picture-options = "scaled";
        primary-color = "#94aada";
      };
      "org/gnome/desktop/wm/keybindings" = {
        close = [ "<Super>q" ];
        toggle-maximized = [ "<Super>m" ];
        switch-to-workspace-1 = [ "<Super>1" ];
        switch-to-workspace-2 = [ "<Super>2" ];
        switch-to-workspace-3 = [ "<Super>3" ];
        switch-to-workspace-4 = [ "<Super>4" ];
        activate-window-menu = [ ];
      };
      "org/gnome/shell/keybindings" = {
        switch-to-application-1 = [ ];
        switch-to-application-2 = [ ];
        switch-to-application-3 = [ ];
        switch-to-application-4 = [ ];
        toggle-message-tray = [ "<Super>v" ];
      };
      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
        ];
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        name = "Launch Terminal";
        command = "ghostty";
        binding = "<Super>Return";
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
        name = "Launch Vicinae";
        command = "vicinae toggle";
        binding = "<Alt>space";
      };
    };
  };
}
