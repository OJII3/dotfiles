# Base desktop configuration
# Applied when my.darwin.desktop.enable is true
{ config, lib, pkgs, inputs, ... }:
let
  cfg = config.my.darwin.desktop;
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      vim
      git
      gnumake
      python312
    ];

    security.pam.services.sudo_local.touchIdAuth = true;

    system.primaryUser = "ojii3";
    system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
    system.startup.chime = false;
    system.keyboard = {
      enableKeyMapping = true;
    };
    system.defaults = {
      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        "com.apple.trackpad.scaling" = 10.0;
        "com.apple.swipescrolldirection" = true; # Natural scrolling
      };
      controlcenter = {
        BatteryShowPercentage = true;
        Bluetooth = false;
        Display = false;
        Sound = true;
      };
      finder = {
        AppleShowAllFiles = true;
        AppleShowAllExtensions = true;
        CreateDesktop = false;
        NewWindowTarget = "Home";
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
          { app = "/Applications/Safari.app"; }
          { app = "/Applications/ChatGPT.app"; }
          { app = "/Applications/Affinity Photo 2.app/"; }
        ];
      };
      screencapture = {
        location = "/Users/ojii3/Pictures/Screenshots";
        type = "png";
      };
    };
  };
}
