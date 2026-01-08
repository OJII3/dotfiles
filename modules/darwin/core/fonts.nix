# Fonts configuration
# Applied when dot.darwin.core.fonts.enable is true
{ config, lib, ... }:
let
  cfg = config.dot.darwin.core;
in
{
  config = lib.mkIf (cfg.enable && cfg.fonts.enable) {
    # nix-darwin's font management does not work well
    homebrew.casks = [
      "font-udev-gothic-nf"
      "font-noto-sans-cjk-jp"
      "font-noto-serif-cjk-jp"
    ];
  };
}
