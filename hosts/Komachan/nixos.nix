# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, pkgs, ... }:
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../modules/core
      ../../modules/desktop
      ../../modules/desktop/tuigreet.nix
    ]
    ++ (with inputs.nixos-hardware.nixosModules; [
      lenovo-thinkpad-e14-amd
    ]);

  # Bootloader.
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen; # for waydroid
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      #     efiSysMountPoint = "/boot";
    };
    systemd-boot.enable = true;
  };


  # graphics
  hardware.graphics = {
    enable32Bit = true;
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
  services.tlp.enable = true;
  services.tlp.settings =
    {
      START_CHARGE_THRESH_BAT0 = 80;
      STOP_CHARGE_THRESH_BAT0 = 95;
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      ENERGY_PERF_POLICY_ON_AC = "performance";
      ENERGY_PERF_POLICY_ON_BAT = "powersave";
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;
    };

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

