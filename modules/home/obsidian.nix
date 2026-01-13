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
  isDarwin = pkgs.stdenv.isDarwin;
in
{
  config = lib.mkIf cfg.enable {
    # Install Obsidian package (Linux only, macOS uses Homebrew cask)
    home.packages = lib.mkIf (!isDarwin) [ pkgs.obsidian ];
  };
}
