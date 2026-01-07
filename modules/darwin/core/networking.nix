{ username, ... }:
{
  imports = [ ./. ];
  networking.knownNetworkServices = [
    "USB 10/100/1000 LAN"
    "Thunderbolt Bridge"
    "Wi-Fi"
  ];
  homebrew.masApps = {
    tailscale = 1475387142;
  };
  environment.shellAliases = {
    tailscale = "/Applications/Tailscale.app/Contents/MacOS/Tailscale";
  };
  services.openssh.enable = true;
}
