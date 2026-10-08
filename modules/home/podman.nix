{ config, lib, pkgs, ... }:
let
  cfg = config.dot.home;
in
{
  config = lib.mkIf cfg.podman.enable {
    services.podman.enable = true;
    home.packages = [ pkgs.podman-compose ];
  };
}
