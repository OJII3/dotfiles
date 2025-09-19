# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, pkgs, ... }:
{
  imports =
    [
      ../../modules/nixos/core
      ../../modules/nixos/core/boot/systemd-boot.nix
      ../../modules/nixos/core/networking/base.nix
      ../../modules/nixos/core/virtualisation.nix
      ../../modules/nixos/core/proxmox.nix

      # ../../modules/nixos/desktop
      # ../../modules/nixos/desktop/greetd/autologin.nix
      # ../../modules/nixos/desktop/sunshine.nix

      ../../modules/nixos/server/adguard.nix
      ../../modules/nixos/server/autologin.nix

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
    ipAddress = "192.168.8.20";
  };
  services.proxmox-ve.bridges = [ "vmbr0" ];

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
    addresses = [{ Address = "192.168.8.20/24"; }];
    gateway = [ "192.168.8.1" ];
    dns = [ "8.8.8.8" "1.1.1.1" ];
    linkConfig.RequiredForOnline = "routable";
  };

  networking = {
    wireless.enable = true;
    wireless.secretsFile = "/etc/nixos/wireless.conf"; # psk_home=******
    wireless.networks."aterm-44cbf4-a" = { pskRaw = "ext:psk_home"; };
    wireless.networks."aterm-44cbf4-g" = { pskRaw = "ext:psk_home"; };
  };

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

  services.cloudflared = {
    enable = true;
    tunnels = {
      "9979507e-fc6a-4418-9bbf-06e7bd5305db" = {
        credentialsFile = "/home/ojii3/.cloudflared/9979507e-fc6a-4418-9bbf-06e7bd5305db.json";
        certificateFile = "/home/ojii3/.cloudflared/cert.pem";
        ingress."cipher.ojii3.dev" = "https://localhost:8006";
        default = "http_status:404";
        originRequest.noTLSVerify = true;
        warp-routing.enabled = true;
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

