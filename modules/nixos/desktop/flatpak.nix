# Flatpak configuration
{ config, lib, pkgs, ... }:
let
  cfg = config.dot.desktop;
in
{
  config = lib.mkIf (cfg.enable && cfg.flatpak.enable) {
    services.flatpak.enable = true;
    systemd.services.flatpak-repo = {
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.flatpak ];
      script = ''
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
      '';
    };
  };
}
