{ inputs, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    vim
    git
    gnumake
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
      expose-group-apps = true;
      orientation = "bottom";
      show-recents = false;
      wvous-bl-corner = 7;
      wvous-br-corner = 1;
      persistent-apps = [
        { app = "/Applications/Safari.app"; }
        { app = "/Applications/Affinity Designer 2.app/"; }
        { app = "/Applications/Affinity Photo 2.app/"; }
      ];
    };
    CustomUserPreferences = {
      "com.apple.screencapture" = {
        location = "~/Pictures/Schreenshots";
        type = "png";
      };
    };
  };
}
