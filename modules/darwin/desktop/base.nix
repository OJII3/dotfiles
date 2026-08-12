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
      userKeyMapping = [
        {
          # Japanese Kana -> Globe (Fn)
          HIDKeyboardModifierMappingSrc = 30064771216;
          HIDKeyboardModifierMappingDst = 1095216660483;
        }
        {
          # Japanese Eisu -> Left Option
          HIDKeyboardModifierMappingSrc = 30064771217;
          HIDKeyboardModifierMappingDst = 30064771298;
        }
      ];
      nonUS.remapTilde = true;
    };
    system.defaults = {
      NSGlobalDomain = {
        AppleInterfaceStyleSwitchesAutomatically = true;
        AppleShowAllExtensions = true;
        AppleSpacesSwitchOnActivate = true;

        "com.apple.trackpad.scaling" = 10.0;
        "com.apple.swipescrolldirection" = true;
        "com.apple.keyboard.fnState" = true;
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
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        CreateDesktop = false;
        FXRemoveOldTrashItems = true;
        NewWindowTarget = "Home";
        QuitMenuItem = true;
        ShowPathbar = true;
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
