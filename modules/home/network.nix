{ config, lib, pkgs, ... }:
let
  cfg = config.my.home;
in
{
  config = lib.mkIf cfg.network.enable {
    home.packages = with pkgs; [
      wireshark
      whois
      traceroute
      tcpdump
      wakeonlan
      ethtool
    ];
  };
}
