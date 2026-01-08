# VR development configuration
# Applied when dot.darwin.desktop.vr.enable is true
{ config, lib, username, ... }:
let
  cfg = config.dot.darwin.desktop;
in
{
  config = lib.mkIf (cfg.enable && cfg.vr.enable) {
    homebrew = {
      taps = [
        "Oculus-VR/tap"
      ];
      brews = [
        "meta-xr-simulator"
      ];
    };

    environment.variables = {
      XR_RUNTIME_JSON = "/Users/${username}/Library/MetaXR/MetaXRSimulator/71.0.0/meta_xr_simulator.json";
    };
  };
}
