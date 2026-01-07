# Base darwin configuration
# Applied when my.darwin.core.enable is true
{ config, lib, inputs, ... }:
let
  cfg = config.my.darwin.core;
in
{
  config = lib.mkIf cfg.enable {
    nix.enable = false;
    environment.pathsToLink = [
      "/share/zsh"
    ];
  };
}
