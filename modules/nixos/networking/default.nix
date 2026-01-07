# NixOS Networking modules
# Network configuration with firewall, Tailscale, DNS, and NetworkManager.
#
# Options:
#   my.networking.enable              - Enable networking configuration
#   my.networking.firewall.enable     - Enable firewall
#   my.networking.tailscale.enable    - Enable Tailscale VPN
#   my.networking.dns.resolved.enable - Enable systemd-resolved with DoT
#   my.networking.networkManager.enable - Enable NetworkManager
#   my.networking.warp.enable         - Enable Cloudflare WARP
#
{ config, lib, pkgs, hostname, ... }:
let
  cfg = config.my.networking;
in
{
  options.my.networking = {
    enable = lib.mkEnableOption "networking configuration" // {
      default = true;
    };

    firewall = {
      enable = lib.mkEnableOption "firewall" // {
        default = true;
      };

      kdeConnect = {
        enable = lib.mkEnableOption "KDE Connect ports (1714-1764)" // {
          default = true;
        };
      };

      ros2 = {
        enable = lib.mkEnableOption "ROS 2 UDP ports (all)" // {
          default = false;  # Security: disabled by default
        };
      };
    };

    tailscale = {
      enable = lib.mkEnableOption "Tailscale VPN" // {
        default = true;
      };
    };

    dns = {
      resolved = {
        enable = lib.mkEnableOption "systemd-resolved with DNS over TLS" // {
          default = true;
        };
      };
    };

    networkManager = {
      enable = lib.mkEnableOption "NetworkManager" // {
        default = false;  # Servers typically use systemd-networkd
      };

      wifi = {
        randomizeMac = lib.mkEnableOption "randomize WiFi MAC address" // {
          default = true;
        };

        powersave = lib.mkEnableOption "WiFi power saving" // {
          default = false;
        };
      };
    };

    warp = {
      enable = lib.mkEnableOption "Cloudflare WARP" // {
        default = false;
      };
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    # Base configuration
    {
      networking.hostName = hostname;

      # Network diagnostic tools
      programs.mtr.enable = true;
      programs.wireshark.enable = true;
    }

    # Firewall
    (lib.mkIf cfg.firewall.enable {
      networking.firewall = {
        enable = true;
        trustedInterfaces = lib.mkIf cfg.tailscale.enable [ "tailscale0" ];
        allowedTCPPortRanges = lib.mkIf cfg.firewall.kdeConnect.enable [
          { from = 1714; to = 1764; }
        ];
        allowedUDPPortRanges = lib.mkMerge [
          (lib.mkIf cfg.firewall.kdeConnect.enable [
            { from = 1714; to = 1764; }
          ])
          (lib.mkIf cfg.firewall.ros2.enable [
            { from = 1; to = 65535; }
          ])
        ];
      };
    })

    # Tailscale
    (lib.mkIf cfg.tailscale.enable {
      services.tailscale = {
        enable = true;
        openFirewall = true;
      };
    })

    # DNS (systemd-resolved)
    # Use mkDefault so AdGuard Home can override (disable) resolved
    (lib.mkIf cfg.dns.resolved.enable {
      services.resolved = {
        enable = lib.mkDefault true;
        dnsovertls = "opportunistic";
      };
    })

    # NetworkManager
    (lib.mkIf cfg.networkManager.enable {
      networking.networkmanager = {
        enable = true;
        wifi = {
          macAddress = if cfg.networkManager.wifi.randomizeMac then "random" else "permanent";
          scanRandMacAddress = false;
          powersave = cfg.networkManager.wifi.powersave;
        };
        dns = lib.mkIf cfg.dns.resolved.enable "systemd-resolved";
      };
    })

    # Cloudflare WARP
    (lib.mkIf cfg.warp.enable {
      services.cloudflare-warp = {
        enable = true;
        openFirewall = true;
      };
    })
  ]);
}
