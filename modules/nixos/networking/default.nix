# NixOS Networking modules
# Network configuration with firewall, Tailscale, DNS, and NetworkManager.
#
# Options: See ./options.nix
#
{ config, lib, hostname, ... }:
let
  cfg = config.dot.networking;
in
{
  imports = [
    ./options.nix
    ./snmpd.nix
    ./warp.nix
  ];

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

  ]);
}
