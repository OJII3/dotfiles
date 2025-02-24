{ pkgs, inputs, ... }: {
  imports = [
    ../../modules/darwin/homebrew.nix
    ../../modules/darwin/window-manager.nix
    ../../modules/darwin/networking.nix
  ];

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    vim
    git
    gnumake
    python311
  ];

  security.pam.enableSudoTouchIdAuth = true;


  # Set Git commit hash for darwin-version.
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
  system.startup.chime = false;
  system.defaults = {
    NSGlobalDomain.AppleShowAllExtensions = true;
    finder = {
      AppleShowAllFiles = true;
      AppleShowAllExtensions = true;
    };
    dock = {
      autohide = true;
      show-recents = false;
      orientation = "left";
    };
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  # The platform the configuration will be used on.
  # nixpkgs.hostPlatform = "aarch64-darwin";
}

