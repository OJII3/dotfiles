# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, pkgs, ... }:

{
  networking.hostName = "Komachan"; # Define your hostname.
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../common
    ]
    ++ (with inputs.nixos-hardware.nixosModules; [
      lenovo-thinkpad-e14-amd
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
  };

  # amd
  hardware.graphics = {
    enable32Bit = true;
    extraPackages = [ pkgs.amdvlk ];
    extraPackages32 = [ pkgs.driversi686Linux.amdvlk ];
  };
  services.xserver.videoDrivers = [ "amdgpu" ];

  #services.flatpak.enable = true;

  virtualisation = {
    waydroid.enable = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    lshw
    wayvnc
    glxinfo
    vulkan-tools
    vulkan-headers
    usbutils
    nix-index
    cloudflared
    # nur.repos.ataraxiasjel.waydroid-script # nur
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
  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    ports = [ 22222 ];
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

  services.fprintd.enable = true;
  security.pam.services.hyprlock.fprintAuth = true;
  security.pam.services.login.fprintAuth = true;

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

