# Blender Launcher V2 - Blender build manager
# Applied when dot.home.blenderLauncher.enable is true
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dot.home.blenderLauncher;
in
{
  config = lib.mkIf cfg.enable {
    home.packages = [
      (pkgs.callPackage ../packages/blender-launcher-v2.nix { })
    ];
  };
}
