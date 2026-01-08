# Bronya - Desktop (NVIDIA Prime, Hyprland)
#
{ inputs, pkgs, ... }:
{
  imports = [
    # Main module with options
    ../../modules/nixos

    ./hardware-configuration.nix
  ]
  ++ (with inputs.nixos-hardware.nixosModules; [
    common-cpu-intel
    common-gpu-nvidia
    common-pc-ssd
  ]);

  # ===== Options-based configuration =====
  dot = {
    core = {
      enable = true;
      boot.loader = "systemd-boot";
      virtualisation.podman.enable = true;
    };

    networking = {
      networkManager.enable = true;
      firewall.ros2.enable = true;
    };

    desktop = {
      enable = true;
      hyprland.enable = true;
      fonts.enable = true;
      sunshine.enable = true;
      waydroid.enable = true;
      peripheral.keyboard.enable = true;
      greetd = {
        enable = true;
        greeter = "autologin";
      };
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
