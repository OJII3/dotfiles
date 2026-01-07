# Cipher - Home Server
# AdGuard Home DNS, static IP, headless autologin
#
{ inputs, pkgs, ... }:
{
  imports = [
    # Main module with options
    ../../modules/nixos

    # Not yet optionized
    ../../modules/nixos/core/boot/systemd-boot.nix
    ../../modules/nixos/core/networking/base.nix
    ../../modules/nixos/core/virtualisation/podman.nix
    ../../modules/nixos/server/gnome-keyring.nix

    ./hardware-configuration.nix
  ]
  ++ (with inputs.nixos-hardware.nixosModules; [
    common-cpu-intel
    common-pc-ssd
  ]);

  # ===== Options-based configuration =====
  my = {
    core = {
      enable = true;
      audio.enable = false;      # Headless server
      bluetooth.enable = false;  # No Bluetooth needed
      ssh.enable = true;
    };

    server = {
      enable = true;
      autologin.enable = true;
      adguardHome.enable = true;
    };

    hardware = {
      gpu = "intel";
    };
  };

  # ===== Host-specific configuration =====

  # Kernel
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen;

  # Static IP networking
  networking.useNetworkd = true;
  systemd.network.networks."10-lan" = {
    matchConfig.Name = "enp3s0";
    networkConfig = {
      IPv6AcceptRA = true;
    };
    addresses = [ { Address = "192.168.8.2/24"; } ];
    gateway = [ "192.168.8.1" ];
    linkConfig.RequiredForOnline = "routable";
  };

  system.stateVersion = "24.05";
}
