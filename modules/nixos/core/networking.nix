{ hostname, pkgs, ... }:
{
  # basic configuration
  programs.mtr.enable = true; # ping x traceroute
  programs.wireshark.enable = true;

  networking.hostName = hostname;
  networking.networkmanager = {
    enable = true;
    wifi = {
      macAddress = "random";
      scanRandMacAddress = false;
      powersave = false;
    };
    dns = "systemd-resolved";
  };

  networking.firewall = {
    enable = true;
    trustedInterfaces = [ "tailscale0" ];
    allowedTCPPorts = [
      7236
      7777
    ]; # VNC, Uniy programs
    allowedUDPPorts = [
      7236
      7777
      9000 # Unitree G1
      9001 # Unitree G1
      9009 # Unitree G1
    ]; # VNC
    allowedTCPPortRanges = [
      {
        from = 1714;
        to = 1764;
      } # KDE Connect
    ];
    allowedUDPPortRanges = [
      {
        from = 1714;
        to = 1764;
      } # KDE Connect
    ];
  };

  services.resolved = {
    enable = true;
    settings.Resolve.DNSOverTLS = "opportunistic";
  };

  services.cloudflare-warp = {
    enable = true;
    openFirewall = true;
  };

  # vpn & device syncing
  services.tailscale = {
    enable = true;
    openFirewall = true;
  };
  programs.kdeconnect.enable = true;
}
