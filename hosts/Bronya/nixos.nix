# Bronya - Desktop (NVIDIA Prime, Hyprland)
#
{ inputs, pkgs, ... }:
{
  imports = [
    # Main module with options
    ../../modules/nixos

    # Not yet optionized
    ../../modules/nixos/core/boot/systemd-boot.nix
    ../../modules/nixos/core/networking
    ../../modules/nixos/core/networking/networkmanager.nix
    ../../modules/nixos/core/virtualisation/podman.nix
    ../../modules/nixos/desktop/greetd/autologin.nix
    ../../modules/nixos/desktop/peripheral/keyboard.nix

    ./hardware-configuration.nix
  ]
  ++ (with inputs.nixos-hardware.nixosModules; [
    common-cpu-intel
    common-gpu-nvidia
    common-pc-ssd
  ]);

  # ===== Options-based configuration =====
  my = {
    core.enable = true;

    desktop = {
      enable = true;       # Enables Hyprland
      fonts.enable = true;
      sunshine.enable = true;
      waydroid.enable = true;
    };

    hardware = {
      gpu = "nvidia";
      nvidia = {
        open = true;
        prime = {
          enable = true;
          offload.enable = true;
          # sync.enable = false;  # offload and sync cannot be enabled at the same time
          intelBusId = "PCI:0:2:0";
          nvidiaBusId = "PCI:1:0:0";
        };
      };
    };
  };

  # ===== Host-specific configuration =====

  # Kernel
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen;

  # Wake-on-LAN
  networking.interfaces."enp4s0".wakeOnLan.enable = true;

  system.stateVersion = "24.05";
}
