{ pkgs, inputs, ... }: {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    vim
    git
    gnumake
    python311
  ];

  services.tailscale = {
    enable = true;
    overrideLocalDns = true;
  };
  services.yabai = {
    enable = true;
    config = {
      layout = "bsp";
      window_placement = "second_child";
      window_animation_duration = 0.2;
      window_gap = 8;
      top_padding = 6;
      bottom_padding = 6;
      left_padding = 6;
      right_padding = 6;
    };
    extraConfig = "
      yabai -m rule --add app='System Settings' manage=off
    ";
  };
  services.skhd = {
    enable = true;
    skhdConfig = "
      cmd - h : yabai -m window --focus west
      cmd - l : yabai -m window --focus east
      cmd - j : yabai -m window --focus south
      cmd - k : yabai -m window --focus north

      cmd + shift - h : yabai -m window --warp west
      cmd + shift - l : yabai -m window --warp east
      cmd + shift - j : yabai -m window --warp south
      cmd + shift - k : yabai -m window --warp north

      cmd - 1 : yabai -m space --forcus 1
      cmd - 2 : yabai -m space --forcus 2
      cmd - 3 : yabai -m space --forcus 3
      cmd - 4 : yabai -m space --forcus 4
      cmd - 5 : yabai -m space --forcus 5

      cmd + shift - 1 : yabai -m window --space 1; yabai -m space --focus 1
      cmd + shift - 2 : yabai -m window --space 2; yabai -m space --focus 2
      cmd + shift - 3 : yabai -m window --space 3; yabai -m space --focus 3
      cmd + shift - 4 : yabai -m window --space 4; yabai -m space --focus 4
      cmd + shift - 5 : yabai -m window --space 5; yabai -m space --focus 5

      cmd + shift - f : yabai -m window --toggle float

      cmd - return : kitty
    ";
  };
  services.jankyborders = {
    enable = true;
    active_color = "gradient(top_left=0x039393ff,bottom_right=0xf992b3ff)";
    inactive_color = "0x00000000";
  };
  networking.knownNetworkServices = [
    "USB 10/100/1000 LAN"
    "Thunderbolt Bridge"
    "Wi-Fi"
  ];

  homebrew = {
    enable = true;
    casks = [
      "karabiner-elements"
    ];
    onActivation = { autoUpdate = true; cleanup = "uninstall"; upgrade = true; };
  };

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

