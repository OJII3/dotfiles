{ config, lib, ... }:
let
  cfg = config.dot.darwin.core;
in
{
  config = lib.mkIf cfg.enable {
    homebrew = {
      enable = true;
      onActivation = {
        upgrade = true;
        autoUpdate = false;
        cleanup = "uninstall";
      };
    };
  };
}
