{ inputs, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    vim
    git
    gnumake
    clang-tools
    python311
  ];

  system.primaryUser = "ojii3";
  security.pam.services.sudo_local.touchIdAuth = true;
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
  system.startup.chime = false;
  system.defaults = {
    NSGlobalDomain = {
      AppleShowAllExtensions = true;
      "com.apple.trackpad.scaling" = 10.0;
      "com.apple.swipescrolldirection" = true; # Natural scrolling
    };
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
