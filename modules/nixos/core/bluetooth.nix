# Bluetooth support.
{ config, lib, ... }:
let
  cfg = config.dot.core;
in
{
  config = lib.mkIf (cfg.enable && cfg.bluetooth.enable) {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Experimental = true;
        };
      };
    };
  };
}
