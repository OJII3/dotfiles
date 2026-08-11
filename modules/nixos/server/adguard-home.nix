# AdGuard Home DNS サーバー。53 番を専有するため systemd-resolved を止める。
{ config, lib, ... }:
let
  cfg = config.dot.server;
in
{
  config = lib.mkIf (cfg.enable && cfg.adguardHome.enable) {
    services.adguardhome = {
      enable = true;
      openFirewall = true;
    };
    services.resolved.enable = false;
  };
}
