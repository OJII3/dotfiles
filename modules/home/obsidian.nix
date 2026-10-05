# Obsidian note-taking app
# Applied when dot.home.obsidian.enable is true
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dot.home.obsidian;
in
{
  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.obsidian ];
  };
}
