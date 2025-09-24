# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ../../modules/nixos/core
    ../../modules/nixos/core/boot/systemd-boot.nix
    ../../modules/nixos/core/networking/base.nix
    ../../modules/nixos/core/virtualisation.nix
    # ../../modules/nixos/core/proxmox.nix
    ../../modules/nixos/core/sops.nix

    ../../modules/nixos/server/adguard.nix
    ../../modules/nixos/server/autologin.nix
    ../../modules/nixos/server/nextcloud
    ../../modules/nixos/server/lfs

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

  # proxomox-ve host ip
  # services.proxmox-ve = {
  #   ipAddress = "192.168.8.20";
  # };
  # services.proxmox-ve.bridges = [ "vmbr0" ];

  # networking
  networking.useNetworkd = true;
  systemd.network.networks."10-lan" = {
    matchConfig.Name = [ "enp3s0" ];
    networkConfig = {
      Bridge = "vmbr0";
    };
  };
  systemd.network.networks."20-lan" = {
    matchConfig.Name = [ "tap*" ];
    networkConfig = {
      Bridge = "vmbr0";
    };
  };
  systemd.network.netdevs."vmbr0" = {
    netdevConfig = {
      Name = "vmbr0";
      Kind = "bridge";
    };
  };
  systemd.network.networks."10-lan-bridge" = {
    matchConfig.Name = "vmbr0";
    networkConfig = {
      IPv6AcceptRA = true;
      # DHCP = "ipv4";
    };
    addresses = [ { Address = "192.168.8.20/24"; } ];
    gateway = [ "192.168.8.1" ];
    dns = [
      "8.8.8.8"
      "1.1.1.1"
    ];
    linkConfig.RequiredForOnline = "routable";
  };

  networking = {
    wireless.enable = true;
    wireless.secretsFile = "/etc/nixos/wireless.conf"; # psk_home=******
    wireless.networks."aterm-44cbf4-a" = {
      pskRaw = "ext:psk_home";
    };
    wireless.networks."aterm-44cbf4-g" = {
      pskRaw = "ext:psk_home";
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
