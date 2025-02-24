{ ... }: {
  networking.knownNetworkServices = [
    "USB 10/100/1000 LAN"
    "Thunderbolt Bridge"
    "Wi-Fi"
  ];
  services.tailscale = {
    enable = true;
    overrideLocalDns = true;
  };
}
