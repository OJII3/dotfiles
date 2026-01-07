{ config, lib, pkgs, ... }:
let
  cfg = config.my.home.dev.ai;
in
{
  config = lib.mkIf cfg.codex.enable {
    home.packages = with pkgs; [
      codex
    ];
  };
}
