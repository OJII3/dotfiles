{ config, lib, pkgs, ... }:
let
  cfg = config.dot.home.dev;
in
{
  config = lib.mkIf cfg.zellij.enable {
    home.packages = [ pkgs.zellij ];
    home.file.".config/zellij/config.kdl".source = ./config.kdl;
  };
}
