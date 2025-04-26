# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, pkgs, ... }:
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../modules/nixos/core
      ../../modules/nixos/desktop
      ../../modules/nixos/desktop/tuigreet.nix
    ]
    ++ (with inputs.nixos-hardware.nixosModules; [
      lenovo-thinkpad-e14-amd
      common-pc-laptop # includes power management
    ]);

  # Bootloader.
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen; # for waydroid
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
    systemd-boot.enable = false;
    grub = {
      enable = true;
      devices = [ "nodev" ];
      useOSProber = true;
      efiSupport = true;
    };
  };
  boot.kernelParams = [
    "amd_iommmu=on"
    "mem_sleep_default=deep"
  ];

  # graphics
  hardware.graphics = {
    extraPackages = [ pkgs.amdvlk ];
    extraPackages32 = [ pkgs.driversi686Linux.amdvlk ];
  };
  services.xserver.videoDrivers = [ "amdgpu" ];

  # system packages
  environment.systemPackages = with pkgs; [
    glxinfo
    vulkan-tools
    vulkan-headers
    # nur.repos.ataraxiasjel.waydroid-script # nur
  ];


  # services.cloudflared = {
  #   enable = true;
  #   group = "cloudflared";
  # };
  services.fprintd.enable = true;
  security.pam.services.hyprlock.fprintAuth = true;
  security.pam.services.login.fprintAuth = true;

  # Others
  virtualisation = {
    waydroid.enable = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}

