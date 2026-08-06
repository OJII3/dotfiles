# VR development configuration
# Applied when dot.darwin.desktop.vr.enable is true
{
  config,
  lib,
  username,
  inputs,
  ...
}:
let
  cfg = config.dot.darwin.desktop;
  simulatorRoot = "/Users/${username}/Library/MetaXR/MetaXRSimulator";
  simulatorRuntime = "${simulatorRoot}/current/meta_openxr_simulator.json";
  simulatorSource = "${config.homebrew.prefix}/opt/meta-xr-simulator";
in
{
  config = lib.mkIf (cfg.enable && cfg.vr.enable) {
    nix-homebrew = {
      taps."oculus-vr/tap" = inputs.oculus-vr-tap;
      trust = {
        taps = [ "oculus-vr/tap" ];
      };
    };

    homebrew = {
      brews = [
        "meta-xr-simulator"
      ];
    };
    #
    environment.variables = {
      XR_RUNTIME_JSON = simulatorRuntime;
    };

    system.activationScripts = {
      install-meta-xr-simulator = {
        text = "";
      };
    };
  };
}
