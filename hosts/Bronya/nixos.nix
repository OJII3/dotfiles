# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, pkgs, ... }:
{
  imports =
    [
      ../../modules/nixos/core
      ../../modules/nixos/core/boot/systemd-boot.nix
      ../../modules/nixos/core/virtualisation.nix
      ../../modules/nixos/core/proxmox.nix

      ../../modules/nixos/desktop
      ../../modules/nixos/desktop/greetd/autologin.nix
      ../../modules/nixos/desktop/sunshine.nix

      ./hardware-configuration.nix
    ]
    ++ (with inputs.nixos-hardware.nixosModules; [
      common-cpu-intel
      common-gpu-nvidia
      common-pc-ssd
    ]);


  # Karnel
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen; # for waydroid


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


  # networking
  networking.useNetworkd = true;
  networking.networkmanager.enable = false;
  networking.interfaces."wlo1" = {
    ipv4.addresses = [{
      address = "192.168.0.99";
      prefixLength = 24;
    }];
  };
  networking.defaultGateway = {
    interface = "wlo1";
    address = "192.168.0.1";
  };
  networking.nameservers = [ "8.8.8.8" "1.1.1.1" ];
  networking = {
    wireless.enable = true;
    wireless.secretsFile = "/etc/nixos/wireless.conf"; # psk_home=******
    wireless.networks."aterm-44cbf4-a" = { pskRaw = "ext:psk_home"; };
    wireless.networks."aterm-44cbf4-g" = { pskRaw = "ext:psk_home"; };
  };

  # bridges for proxmox-nixos
  systemd.network.netdevs."vmbr0".netdevConfig = {
    Name = "vmbr0";
    Kind = "bridge";
  };
  systemd.network.networks."00-lan0" = {
    matchConfig.Name = "enp4s0";
    networkConfig = { Bridge = "vmbr0"; };
  };
  systemd.network.networks."10-vmbr0" =
    {
      matchConfig.Name = "vmbr0";
      networkConfig = {
        Address = "10.42.0.2/24";
        Gateway = "10.42.0.1";
      };
    };
  systemd.network.networks."20-lan-bridge" = {
    matchConfig.Name = "vmbr0";
    networkConfig = {
      IPv6AcceptRA = true;
      DHCP = "ipv4";
    };
    linkConfig.RequiredForOnline = "routable";
  };
  # systemd.network.networks."30-tap0" = {
  #   matchConfig.Name = "tap*";
  #   networkConfig = { Bridge = "vmbr0"; };
  # };

  # open firewall for dhcp and dns
  services.proxmox-ve = {
    ipAddress = "10.42.0.2";
    bridges = [ "vmbr0" ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}

