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
    ../../includes/nixos/core
    ../../includes/nixos/core/boot/systemd-boot.nix
    ../../includes/nixos/core/networking/base.nix
    ../../includes/nixos/core/networking/dns.nix
    ../../includes/nixos/core/virtualisation.nix
    # ../../includes/nixos/core/proxmox.nix
    ../../includes/nixos/core/sops.nix

    ../../includes/nixos/server/adguard.nix
    ../../includes/nixos/server/autologin.nix

    ./hardware-configuration.nix
  ]
  ++ (with inputs.nixos-hardware.nixosModules; [
    common-cpu-intel
    common-pc-ssd
  ]);

  # Kernel
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen; # for waydroid

  # graphics
  # services.xserver.videoDrivers = [ "intel" ];

  # networking
  networking.useNetworkd = true;
  systemd.network.networks."10-lan" = {
    matchConfig.Name = "enp3s0";
    networkConfig = {
      IPv6AcceptRA = true;
      # DHCP = "ipv4";
    };
    addresses = [ { Address = "192.168.8.2/24"; } ];
    gateway = [ "192.168.8.1" ];
    linkConfig.RequiredForOnline = "routable";
  };

  networking = {
    wireless.enable = false;
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
