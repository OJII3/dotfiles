# NixOS Networking module options
{ lib, ... }:
{
  options.dot.networking = {
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
          default = false; # Security: disabled by default
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
        default = false; # Servers typically use systemd-networkd
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

    snmpd = {
      enable = lib.mkEnableOption "SNMP daemon" // {
        default = false;
      };

      location = lib.mkOption {
        type = lib.types.str;
        default = "Default Room";
        description = "Physical location of the system";
      };

      contact = lib.mkOption {
        type = lib.types.str;
        default = "sysadmin@example.com";
        description = "Contact information for system administrator";
      };

      community = lib.mkOption {
        type = lib.types.str;
        default = "public";
        description = "SNMP community string (consider using secrets management)";
      };

      listenAddress = lib.mkOption {
        type = lib.types.str;
        default = "0.0.0.0:161";
        description = "Address and port to listen on";
      };
    };
  };
}
