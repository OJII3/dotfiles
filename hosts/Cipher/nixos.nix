# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, lib, pkgs, ... }:
{
  imports =
    [
      # ../../modules/nixos/core/k3s.nix
      ../../modules/nixos/core
      ../../modules/nixos/core/networking
      ../../modules/nixos/core/proxmox.nix
      ../../modules/nixos/core/boot/systemd-boot.nix

      ../../modules/nixos/desktop
      ../../modules/nixos/desktop/greetd/autologin.nix
      ../../modules/nixos/desktop/sunshine.nix

      ./hardware-configuration.nix
    ]
    ++ (with inputs.nixos-hardware.nixosModules; [
      common-cpu-intel
      common-pc-ssd
    ]);


  # Kernel
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen; # for waydroid

  # graphics
  services.xserver.videoDrivers = [ "intel" ];

  # networkd
  # networking.bridges.vmbr0.interfaces = [ "enp3s0" ];
  # networking.interfaces.vmmbr0.useDHCP = lib.mkDefault true;

  networking.useNetworkd = true;
  networking.networkmanager.enable = false;
  networking.interfaces."wlp1s0" = {
    ipv4.addresses = [{
      address = "192.168.0.100";
      prefixLength = 24;
    }];
  };
  networking.defaultGateway = {
    interface = "wlp1s0";
    address = "192.168.0.1";
  };
  networking.nameservers = [ "8.8.8.8" "1.1.1.1" ];
  networking = {
    wireless.enable = true;
    wireless.networks."aterm-44cbf4-a" = {
      pskRaw = "f28bf2655884695d0ea0948f78334b2885c9f13152d7f9af11b98ca134ea4d54";
    };
  };
  services.proxmox-ve = {
    ipAddress = "192.168.0.100";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
