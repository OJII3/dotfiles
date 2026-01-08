# Desktop module options
# All option definitions for dot.desktop.*
{ lib, ... }:
{
  options.dot.desktop = {
    enable = lib.mkEnableOption "desktop environment";

    hyprland = {
      enable = lib.mkEnableOption "Hyprland compositor";
    };

    fonts = {
      enable = lib.mkEnableOption "custom fonts configuration";
    };

    flatpak = {
      enable = lib.mkEnableOption "Flatpak support";
    };

    sunshine = {
      enable = lib.mkEnableOption "Sunshine remote desktop";
    };

    waydroid = {
      enable = lib.mkEnableOption "Waydroid Android container";
    };

    keyd = {
      enable = lib.mkEnableOption "keyd key remapping";
    };

    gaming = {
      enable = lib.mkEnableOption "gaming support";

      steam = {
        enable = lib.mkEnableOption "Steam" // {
          default = true; # Enable by default when gaming is enabled
        };
      };

      vr = {
        enable = lib.mkEnableOption "VR support (Monado, etc.)";
      };
    };

    greetd = {
      enable = lib.mkEnableOption "greetd login manager";

      greeter = lib.mkOption {
        type = lib.types.enum [ "autologin" "tuigreet" ];
        default = "tuigreet";
        description = "Greeter type: autologin (direct login) or tuigreet (TUI greeter)";
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "ojii3";
        description = "User to log in as";
      };

      sessionCommand = lib.mkOption {
        type = lib.types.str;
        default = "uwsm start -- hyprland-uwsm.desktop";
        description = "Session command to run after login";
      };
    };

    peripheral = {
      keyboard = {
        enable = lib.mkEnableOption "Keychron keyboard udev rules for VIA";
      };
    };

    bitwarden = {
      enable = lib.mkEnableOption "Bitwarden desktop password manager";
    };
  };
}
