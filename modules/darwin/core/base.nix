# Base darwin configuration
# Applied when dot.darwin.core.enable is true
{ config, lib, inputs, ... }:
let
  cfg = config.dot.darwin.core;
in
{
  config = lib.mkIf cfg.enable {
    nix.enable = false;
    environment.pathsToLink = [
      "/share/zsh"
    ];
  };
}
