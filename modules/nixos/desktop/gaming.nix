# Gaming configuration (Steam, VR)
{ config, lib, pkgs, ... }:
let
  cfg = config.my.desktop;
in
{
  config = lib.mkIf cfg.enable (lib.mkMerge [
    # Steam
    (lib.mkIf (cfg.gaming.enable && cfg.gaming.steam.enable) {
      programs.steam = {
        enable = true;
        dedicatedServer.openFirewall = true;
        fontPackages = [ pkgs.migu ];
        extraCompatPackages = [ pkgs.proton-ge-bin ];
      };
    })

    # VR (Monado, etc.)
    (lib.mkIf (cfg.gaming.enable && cfg.gaming.vr.enable) {
      environment.systemPackages = [ pkgs.wlx-overlay-s ];
      programs.immersed.enable = true;

      services.monado = {
        enable = true;
        defaultRuntime = true;
      };
      systemd.user.services.monado.environment = {
        STEAMVR_LH_ENABLE = "1";
        XRT_COMPOSITOR_COMPUTE = "1";
      };

      hardware.graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = [ pkgs.libva ];
      };
    })
  ]);
}
