# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, config, pkgs, ... }:
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../modules/core
      ../../modules/desktop
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
    open = true;
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


  # system packages
  environment.systemPackages = with pkgs; [ glxinfo vulkan-tools ];


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
