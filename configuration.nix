# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, config, pkgs, lib, ... }:

{
  # Bootloader.

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Tokyo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ja_JP.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "ja_JP.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "ja_JP.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "ja_JP.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      fcitx5-mozc
      fcitx5-gtk
      fcitx5-skk
    ];
  };

  fonts = {
    packages = with pkgs; [
      noto-fonts-cjk-serif
      noto-fonts-cjk-sans
      noto-fonts-emoji
      twitter-color-emoji
      source-han-sans
      source-han-serif
      jetbrains-mono
      hackgen-nf-font
      nerdfonts
      migu
    ];
    fontDir.enable = true;
    fontconfig = {
      defaultFonts = {
        serif = [ "Noto Serif CJK JP" "Noto Color Emoji" ];
        sansSerif = [ "Noto Sans CJK JP" "Noto Color Emoji" ];
        monospace = [ "JetBrainsMono Nerd Font" "Noto Color Emoji" ];
        emoji = [ "Noto Color Emoji" ];
      };
      # in steam, use Migu 1P font for compatibility
      localConf = ''
        <?xml version="1.0"?>
         <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
         <fontconfig>
           <description>Change default fonts for Steam client</description>
           <match>
             <test name="prgname">
               <string>steamwebhelper</string>
             </test>
             <test name="family" qual="any">
               <string>sans-serif</string>
             </test>
             <edit mode="prepend" name="family">
               <string>Migu 1P</string>
             </edit>
           </match>
         </fontconfig>
      '';
    };
  };

  # services.xserver.enable = true;
  # services.xserver.videoDrivers = [ "nvidiaBeta" ];

  # services.displayManager.sddm.enable = true;
  # services.displayManager.sddm.theme = "chili";
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "Hyprland --config /etc/greetd/hyprland.conf";
        user = "ojii3";
      };
    };
  };
  environment.etc."greetd/hyprland.conf".text = ''
    exec-once = regreet; hyprctl dispatch exit
  '';
  programs.regreet = lib.mkForce {
    enable = true;
    settings = {
      background = {
        path = "/home/ojii3/dotfiles/images/haxxor-bunny.png";
        fit = "Cover";
      };
      GTK = {
        theme_name = "oomox-rose-pine-moon";
        icon_theme_name = "oomox-rose-pine-moon";
        cursor_theme_name = "miku-cursor-linux";
      };
    };
  };

  # Configure keymap in X11
  services.xserver = {
    xkb = {
      variant = "";
      layout = "us";
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # optimus prime
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
      ];
      keymap = [
      ];
    };
  };

  #services.flatpak.enable = true;
  xdg.portal.enable = true;
  xdg.portal.extraPortals = with pkgs; [
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-kde
  ];

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ojii3 = {
    isNormalUser = true;
    description = "ojii3";
    extraGroups = [ "networkmanager" "wheel" "storage" "vboxusers" "wireshark" ];
    packages = with pkgs; [
    ];
    shell = pkgs.zsh;
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
    wireshark.enable = true;
  };
  programs.nix-ld.enable = true;

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
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #   wget
    #   sddm-chili-theme
    #   lshw
    #   kitty
    #   wayvnc
    #   wineWowPackages.staging
    #   winetricks
    #   vulkan-tools
    greetd.regreet
    kdePackages.kwallet
    kdePackages.kwalletmanager
    kdePackages.kwallet-pam
    kdePackages.ksshaskpass
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
  # services.tailscale.enable = true;

  # networking.firewall = {
  #   enable = true;
  #   trustedInterfaces = [ "tailscale0" ];
  #   allowedUDPPorts = [ config.services.tailscale.port ];
  #   allowedTCPPortRanges = [
  #     { from = 1714; to = 1764; } # KDE Connect
  #   ];
  #   allowedUDPPortRanges = [
  #     { from = 1714; to = 1764; } # KDE Connect
  #   ];
  # };

  security.pam.services = {
    greetd.kwallet = {
      enable = true;
      package = pkgs.kdePackages.kwallet-pam;
      forceRun = true;
    };
    login.kwallet = {
      enable = true;
      package = pkgs.kdePackages.kwallet-pam;
      forceRun = true;
    };
  };
  systemd.user.services."plasma-kwallet-pam" = {
    enable = true;
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.kdePackages.kwallet-pam}/libexec/kwallet-pam";
      Restart = "always";
    };
  };
  services.dbus.packages = with pkgs; [
    kdePackages.kwallet
  ];

  services.avahi = {
    enable = true;
    openFirewall = true;
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  programs.kdeconnect.enable = true;

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

