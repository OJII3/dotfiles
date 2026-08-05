{ config, lib, ... }:
let
  cfg = config.dot.home.desktop;
in
{
  config = lib.mkIf cfg.hammerspoon.enable {
    home.file.".hammerspoon/init.lua".source = ./init.lua;
  };
}
