# PipeWire audio.
{ config, lib, ... }:
let
  cfg = config.dot.core;
in
{
  config = lib.mkIf (cfg.enable && cfg.audio.enable) {
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    programs.noisetorch.enable = true;
  };
}
