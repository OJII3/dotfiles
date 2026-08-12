{
  inputs,
  config,
  lib,
  ...
}:
let
  cfg = config.dot.darwin.desktop;
in
{
  config = lib.mkIf (cfg.enable && cfg.rift.enable) {
    assertions = [
      {
        assertion = config.homebrew.enable;
        message = "dot.darwin.desktop.hammerspoon requires homebrew to be enabled (set dot.darwin.core.enable = true)";
      }
    ];

    nix-homebrew = {
      taps."acsandmann/homebrew-tap" = inputs.acsandmann-tap;
      trust = {
        taps = [ "acsandmann/tap" ];
      };
    };

    homebrew = {
      brews = [
        "acsandmann/tap/rift"
      ];
    };
  };
}
