{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dot.home.apps;
in
{
  config = lib.mkIf cfg.darwin.enable {
    home.packages = with pkgs; [
      pngpaste
    ];
  };
}
