# Base darwin configuration
# Applied when dot.darwin.core.enable is true
{ config, lib, ... }:
let
  cfg = config.dot.darwin.core;
in
{
  config = lib.mkIf cfg.enable {
    environment.pathsToLink = [
      "/share/zsh"
    ];
  };
}
