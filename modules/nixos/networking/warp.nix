# Cloudflare WARP configuration
# Provides Cloudflare WARP VPN/DNS proxy service
#
{ config, lib, ... }:
let
  cfg = config.dot.networking.warp;
in
{
  config = lib.mkIf cfg.enable {
    services.cloudflare-warp = {
      enable = true;
      openFirewall = true;
    };
  };
}
