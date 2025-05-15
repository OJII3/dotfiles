# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, pkgs, ... }:
{
  imports =
    [
      ../../modules/nixos/core
      ../../modules/nixos/core/virtualisation.nix
      ../../modules/nixos/desktop
      ../../modules/nixos/desktop/sunshine.nix
      ../../modules/nixos/desktop/waydroid.nix
      ./hardware-configuration.nix
    ]
    ++ (with inputs.nixos-hardware.nixosModules; [
      common-cpu-intel
      common-gpu-nvidia
      common-pc-ssd
    ]);


  # Bootloader.
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen; # for waydroid
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;


  # graphics
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    prime = {
      # sync.enable = true;
      # offload.enable = false;
      offload = {
        # offload and sync cannot be enabled at the same time
        enable = true;
        enableOffloadCmd = true;
      };
      # to check, command `sudo lshw -c diplay`
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
    # package = config.boot.kernelPackages.nvidiaPackages.beta;
  };


  # Wake on LAN
  networking.interfaces.enp4s0.wakeOnLan.enable = true;

  # Auto Login
  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = "uwsm start -- hyprland-uwsm.desktop";
        user = "ojii3";
      };
      default_session = initial_session;
    };
  };



  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
