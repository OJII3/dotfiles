# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, config, pkgs, lib, ... }:

{
  imports = [
    ./i18n.nix
    ./networking.nix
    ./hyprland.nix
  ];
  # Set your time zone.
  time.timeZone = "Asia/Tokyo";

  services.xserver.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  services.devmon.enable = true;

  # Configure keymap in X11
  services.xserver = {
    xkb = {
      variant = "";
      layout = "us";
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  # hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true;
      };
    };
  };

  services.xremap = {
    userName = "ojii3";
    serviceMode = "system";
    config = {
      modmap = [
        {
          name = "Smart CapsLock";
          remap = {
            CapsLock = [ "Ctrl_L" "Esc" ];
          };
        }
        {
          name = "Super Muhenkan";
          remap = {
            Muhenkan = "Super_L";
          };
        }
        {
          name = "Mouse Back to Numpad .";
          remap = {
            BTN_8 = "KEY_KPDOT";
          };
        }
        {
          name = "Space Shift";
          remap = {
            Space = [ "Shift_L" "Space" ];
          };
        }
      ];
      keymap = [
      ];
    };
  };

  #services.flatpak.enable = true;
  xdg.portal.enable = true;
  xdg.portal.extraPortals = with pkgs; [
    xdg-desktop-portal-gtk
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ojii3 = {
    isNormalUser = true;
    description = "ojii3";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "storage" "vboxusers" "wireshark" "dialout" "sys" ];
  };

  programs = {
    git = {
      enable = true;
    };
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
    };
    zsh = {
      enable = true;
    };
    noisetorch.enable = true;
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
  };
  programs.nix-ld.enable = true;

  # install docker by default
  virtualisation = {
    docker = {
      enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
    virtualbox.host.enable = true;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    #   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #   wget
    #   lshw
    #   kitty
    #   wayvnc
    #   wineWowPackages.staging
    #   winetricks
    #   vulkan-tools
  ];
  # environment.pathsToLink = [ "/share/zsh" ];


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh = {
  #   enable = true;
  #   ports = [ 22222 ];
  # };

  security.polkit = {
    enable = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  # system.stateVersion = "24.05"; # Did you read the comment?

  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
}

