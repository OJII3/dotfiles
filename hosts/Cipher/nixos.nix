# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, pkgs, ... }:
{
  imports =
    [
      ../../modules/nixos/core
      ../../modules/nixos/core/boot/systemd-boot.nix
      ../../modules/nixos/core/networking
      ../../modules/nixos/core/proxmox.nix

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

  # proxomox-ve host ip
  services.proxmox-ve = {
    ipAddress = "192.168.0.100";
  };

  # usual network settings
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
    wireless.secretsFile = "/etc/nixos/wireless.conf"; # psk_home=******
    wireless.networks."aterm-44cbf4-a" = { pskRaw = "ext:psk_home"; };
    wireless.networks."aterm-44cbf4-g" = { pskRaw = "ext:psk_home"; };
  };

  # create bridge for mini dhcp server
  systemd.network.netdevs."br0".netdevConfig = {
    Name = "br0";
    Kind = "bridge";
  };
  systemd.network.networks."00-br0" = {
    matchConfig.Name = "br0";
    networkConfig = {
      Address = "10.42.0.1/24";
      DHCPServer = "yes";
    };
    dhcpServerConfig = {
      PoolOffset = 100;
      PoolSize = 100;
    };
  };

  # enp3s0 to br0
  systemd.network.networks."20-enp3s0" = {
    matchConfig.Name = "enp3s0";
    networkConfig = { Bridge = "br0"; };
  };

  # vm taps to br0
  systemd.network.networks."30-tap0" = {
    matchConfig.Name = "tap*";
    networkConfig = { Bridge = "br0"; };
  };

  # nat via wlp1s0
  networking.nat = {
    enable = true;
    externalInterface = "wlp1s0";
    internalInterfaces = [ "br0" ];
  };

  # open firewall for dhcp and dns
  networking.firewall.allowedUDPPorts = [ 53 67 ];
  networking.firewall.allowedTCPPorts = [ 53 ];

  # samba
  services.samba = {
    enable = true;
    securityType = "user";
    openFirewall = true;
    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "server string" = "cipher";
        "netbios name" = "cipher";
        "security" = "user";
        "use sendfile" = "yes";
        #"max protocol" = "smb2";
        # note: localhost is the ipv6 localhost ::1
        "hosts allow" = "*";
        # "hosts deny" = "0.0.0.0/0";
        "guest account" = "nobody";
        "map to guest" = "bad user";
      };
      "Private" = {
        "path" = "/home/ojii3/Shared";
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "ojii3";
        "force group" = "WORKGROUP";
      };
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
