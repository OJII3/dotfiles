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
  config = lib.mkIf (cfg.enable && cfg.vr.enable) {
    environment.systemPackages = [ pkgs.wayvr ];
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
  };
}
