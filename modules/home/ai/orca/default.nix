{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dot.home.ai;
  orca = pkgs.callPackage ./package.nix { };
in
{
  config = lib.mkIf cfg.orca.enable {
    home.packages = [ orca ];
  };
}
