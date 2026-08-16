{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dot.home.desktop;
in
{
  config = lib.mkIf cfg.jankyborders.enable {
    home.packages = [ pkgs.jankyborders ];
    home.file.".config/borders/bordersrc".source = ./bordersrc;
  };
}
