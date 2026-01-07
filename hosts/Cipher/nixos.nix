# Cipher - Home Server
# AdGuard Home DNS, static IP, headless autologin
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
    common-pc-ssd
  ]);

  # ===== Options-based configuration =====
  my = {
    core = {
      enable = true;
      boot.loader = "systemd-boot";
      audio.enable = false;      # Headless server
      bluetooth.enable = false;  # No Bluetooth needed
      ssh.enable = true;
      virtualisation.podman.enable = true;
    };

    networking = {
      # Server uses systemd-networkd, not NetworkManager
      networkManager.enable = false;
    };

    server = {
      enable = true;
      autologin.enable = true;
      adguardHome.enable = true;
      gnomeKeyring.enable = true;
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
