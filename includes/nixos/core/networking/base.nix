{ hostname, pkgs, ... }:
{
  # basic configuration
  programs.mtr.enable = true; # ping x traceroute
  programs.wireshark.enable = true;

  networking.hostName = hostname;

  networking.firewall = {
    enable = true;
    trustedInterfaces = [ "tailscale0" ];
    allowedTCPPorts = [ ];
    allowedUDPPorts = [ ];
    allowedTCPPortRanges = [
      {
        from = 1714;
        to = 1764;
      } # KDE Connect
    ];
    allowedUDPPortRanges = [
      {
        # KDE Connect
        from = 1714;
        to = 1764;
      }
      {
        # ROS 2
        from = 1;
        to = 65535;
      }
    ];
  };

  # vpn & device syncing
  services.tailscale = {
    enable = true;
    openFirewall = true;
  };
  programs.kdeconnect.enable = true;
}
