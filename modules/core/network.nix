{ hostname, ... }: {
  # basic configuration
  programs.mtr.enable = true; # ping x traceroute

  networking.hostName = hostname;
  networking.networkmanager = {
    enable = true;
    wifi = {
      macAddress = "random";
      scanRandMacAddress = true;
    };
  };

  networking.firewall = {
    enable = true;
    trustedInterfaces = [ "tailscale0" ];
    allowedTCPPorts = [ 7236 7777 ]; # VNC, Uniy programs
    allowedUDPPorts = [ 7236 7777 ]; # VNC
    allowedTCPPortRanges = [
      { from = 1714; to = 1764; } # KDE Connect
    ];
    allowedUDPPortRanges = [
      { from = 1714; to = 1764; } # KDE Connect
    ];
  };

  # dns
  services.avahi = {
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
