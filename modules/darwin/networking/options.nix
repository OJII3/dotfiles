{ lib, ... }:
{
  options.dot.darwin.networking = {
    enable = lib.mkEnableOption "networking configuration";

    tailscale = {
      enable = lib.mkEnableOption "Tailscale VPN";
    };

    openssh = {
      enable = lib.mkEnableOption "OpenSSH server";
    };

    cloudflared = {
      enable = lib.mkEnableOption "Cloudflared CLI";
    };
  };
}
