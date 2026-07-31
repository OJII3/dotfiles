# Base desktop configuration
# Applied when dot.darwin.desktop.enable is true
{
  config,
  lib,
  inputs,
  username,
  ...
}:
let
  cfg = config.dot.darwin.desktop;
in
{
  config = lib.mkIf cfg.enable {
    security.pam.services.sudo_local.touchIdAuth = true;

    system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
    system.startup.chime = false;
    system.keyboard = {
      enableKeyMapping = true;
      nonUS.remapTilde = true;
    };
    system.defaults = {
      NSGlobalDomain = {
        AppleInterfaceStyleSwitchesAutomatically = true;
        AppleShowAllExtensions = true;
        AppleSpacesSwitchOnActivate = true;

        "com.apple.trackpad.scaling" = 10.0;
        "com.apple.swipescrolldirection" = true;
      };
      controlcenter = {
        AirDrop = false;
        BatteryShowPercentage = true;
        Bluetooth = false;
        Display = true;
        FocusModes = false;
        NowPlaying = false;
        Sound = true;
      };
      finder = {
        AppleShowAllFiles = true;
        AppleShowAllExtensions = true;
        CreateDesktop = false;
        NewWindowTarget = "Home";
        ShowPathbar = true;
        QuitMenuItem = true;
      };
      dock = {
        autohide = true;
        expose-group-apps = false;
        orientation = "bottom";
        show-recents = false;
        wvous-bl-corner = 7;
        wvous-br-corner = 1;
        persistent-apps = [
          { app = "/System/Applications/System Settings.app"; }
        ];
      };
      screencapture = {
        location = "/Users/${username}/Pictures/Screenshots";
        save-selections = false;
        type = "png";
      };
    };
  };
}
