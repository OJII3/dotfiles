# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, config, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.Komachan.nix
    ]
    ++ (with inputs.nixos-hardware.nixosModules; [
      common-cpu-intel
      common-gpu-nvidia
      common-pc-ssd
    ])
    ++ [
      inputs.xremap.nixosModules.default
    ];

  # Bootloader.
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen;
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      #     efiSysMountPoint = "/boot";
    };
    systemd-boot.enable = true;
    #   grub =
    #     {
    #       enable = true;
    #       efiSupport = true;
    #       device = "/dev/disk/by-uuid/0F55-ACC6";
    #     };
  };

  networking.hostName = "Komachan"; # Define your hostname.
  # networking.wireless.enable = true; # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  # networking.networkmanager.enable = true;
  networking.networkmanager.wifi.macAddress = "random";

  # Set your time zone.
  # time.timeZone = "Asia/Tokyo";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";

  # i18n.extraLocaleSettings = {
  #   LC_ADDRESS = "ja_JP.UTF-8";
  #   LC_IDENTIFICATION = "ja_JP.UTF-8";
  #   LC_MEASUREMENT = "ja_JP.UTF-8";
  #   LC_MONETARY = "ja_JP.UTF-8";
  #   LC_NAME = "ja_JP.UTF-8";
  #   LC_NUMERIC = "ja_JP.UTF-8";
  #   LC_PAPER = "ja_JP.UTF-8";
  #   LC_TELEPHONE = "ja_JP.UTF-8";
  #   LC_TIME = "ja_JP.UTF-8";
  # };

  # i18n.inputMethod = {
  #   enabled = "fcitx5";
  #   fcitx5.addons = with pkgs; [
  #     fcitx5-mozc
  #     fcitx5-gtk
  #     fcitx5-skk
  #   ];
  # };

  # fonts = {
  #   packages = with pkgs; [
  #     noto-fonts-cjk-serif
  #     noto-fonts-cjk-sans
  #     noto-fonts-emoji
  #     source-han-sans
  #     source-han-serif
  #     jetbrains-mono
  #     hackgen-nf-font
  #     nerdfonts
  #     migu
  #   ];
  #   fontDir.enable = true;
  #   fontconfig = {
  #     defaultFonts = {
  #       serif = [ "Source Han Serif" "Noto Color Emoji" ];
  #       sansSerif = [ "Source Han Snas" "Noto Color Emoji" ];
  #       monospace = [ "JetBrainsMono Nerd Font" "Noto Color Emoji" ];
  #       emoji = [ "Noto Color Emoji" ];
  #     };
  #   };
  # };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" ];

  # Configure keymap in X11
  # services.xserver = {
  #   xkb = {
  #     variant = "";
  #     layout = "us";
  #   };
  # };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # optimus prime

  # Enable sound with pipewire.
  # hardware.pulseaudio.enable = false;
  # security.rtkit.enable = true;
  # services.pipewire = {
  #   enable = true;
  #   alsa.enable = true;
  #   alsa.support32Bit = true;
  #   pulse.enable = true;
  #   jack.enable = true;

  # use the example session manager (no others are packaged yet so this is enabled by default,
  # no need to redefine it in your config for now)
  #media-session.enable = true;
  # };

  #services.flatpak.enable = true;

  programs = { };

  virtualisation = {
    waydroid.enable = true;
    #   docker = {
    #     enable = true;
    #     rootless = {
    #       enable = true;
    #       setSocketVariable = true;
    #     };
    #   };
    #   virtualbox.host.enable = true;
  };



  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    lshw
    kitty
    wayvnc
    wineWowPackages.staging
    winetricks
    vulkan-tools
    usbutils
    nix-index
    cloudflared
    # cloudflare-warp # for warp-taskbar, not for warp-cli or warp-svc
    config.nur.repos.ataraxiasjel.waydroid-script # nur
  ];
  environment.pathsToLink = [ "/share/zsh" ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-qt;
  };
  programs.weylus = {
    enable = true;
    users = [ "ojii3" ];
    openFirewall = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    ports = [ 22222 ];
  };
  services.tailscale = {
    enable = true;
    openFirewall = true;
  };
  # make sure to enable auto-connect in the warp profile settings
  # services.cloudflare-warp = {
  #   enable = true;
  #   openFirewall = true;
  # };

  # users.users.cloudflared = {
  #   group = "cloudflared";
  #   isSystemUser = true;
  # };
  # users.groups.cloudflared = { };
  #
  # systemd.services."Komachan_Cloudflared" = {
  #   wantedBy = [ "multi-user.target" ];
  #   after = [ "network.target" ];
  #   serviceConfig = {
  #     ExecStart = "${pkgs.cloudflared}/bin/cloudflared tunnel --no-autoupdate run --token=eyJhIjoiYzQwMGE0ZDA0NGJmNDY1NTAwNmMzMjQ1MDM2ZmRiNjgiLCJ0IjoiNjE5NjYzMjAtNWU3Zi00ZGUwLWE3YmUtN2FmYjVkNWUxNGM3IiwicyI6Ijg2bGp1Z24zQmFuVWxrWnpDM0s4VlNsS1FIS3JsWldIcEI5bTJUdkxJL1k9In0=";
  #     Restart = "always";
  #     User = "cloudflared";
  #     Group = "cloudflared";
  #   };
  # };

  networking.firewall = {
    enable = true;
    trustedInterfaces = [ "tailscale0" "ClourdlareWARP" ];
    allowedTCPPorts = [ 5900 7236 7250 ]; #miracast
    allowedUDPPorts = [ 7236 ]; # VNC
    allowedTCPPortRanges = [
      { from = 1714; to = 1764; } # KDE Connect
    ];
    allowedUDPPortRanges = [
      { from = 1714; to = 1764; } # KDE Connect
    ];
  };

  services.fprintd.enable = true;
  security.pam.services.hyprlock.fprintAuth = true;
  security.pam.services.greetd.fprintAuth = true;
  # security.pam.services.login.fprintAuth = true;
  # security.pam.services.gdm-password.fprintAuth = true;

  services.udisks2.enable = true;
  services.gvfs.enable = true;
  services.devmon.enable = true;

  services.tlp.enable = true;
  services.tlp.settings =
    {
      START_CHARGE_THRESH_BAT0 = 80;
      STOP_CHARGE_THRESH_BAT0 = 95;
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      ENERGY_PERF_POLICY_ON_AC = "performance";
      ENERGY_PERF_POLICY_ON_BAT = "powersave";
    };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

  # nix = {
  #   settings = {
  #     auto-optimise-store = true;
  #     experimental-features = [ "nix-command" "flakes" ];
  #   };
  #   gc = {
  #     automatic = true;
  #     dates = "weekly";
  #     options = "--delete-older-than 7d";
  #   };
  # };
}

