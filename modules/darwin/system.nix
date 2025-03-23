{ inputs, ... }: {
  security.pam.services.sudo_local.touchIdAuth = true;
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
  system.startup.chime = false;
  system.defaults = {
    NSGlobalDomain.AppleShowAllExtensions = true;
    NSGlobalDomain."com.apple.trackpad.scaling" = 10.0;
    controlcenter = {
      BatteryShowPercentage = true;
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
      show-recents = false;
      orientation = "bottom";
      wvous-bl-corner = 7;
      wvous-br-corner = 1;
    };
    CustomUserPreferences = {
      "com.apple.screencapture" = {
        location = "~/Pictures/Schreenshots";
        type = "png";
      };
    };
  };
}
