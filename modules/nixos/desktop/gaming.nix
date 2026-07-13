# Gaming configuration (Steam)
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dot.desktop;
in
{
  config = lib.mkIf (cfg.enable && cfg.gaming.enable && cfg.gaming.steam.enable) {
    programs.steam = {
      enable = true;
      dedicatedServer.openFirewall = true;
      fontPackages = [ pkgs.migu ];
      extraCompatPackages = [ pkgs.proton-ge-bin ];
    };
  };
}
