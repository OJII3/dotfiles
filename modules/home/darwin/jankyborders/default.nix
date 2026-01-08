{ config, lib, ... }:
let
  cfg = config.dot.home.darwin;
in
{
  config = lib.mkIf cfg.jankyborders.enable {
    services.jankyborders = {
      enable = true;
      settings = {
        style = "round";
        hidpi = "off";
        active_color = "0xFFFFA500";
        inactive_color = "0x00000000";
        width = 8.0;
      };
    };
  };
}
