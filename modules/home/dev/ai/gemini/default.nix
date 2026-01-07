{ config, lib, pkgs, ... }:
let
  cfg = config.my.home.dev.ai;
in
{
  config = lib.mkIf cfg.gemini.enable {
    home.packages = with pkgs; [
      gemini-cli-bin
    ];

    home.file.".gemini/settings.json".source = ./settings.json;
    home.file.".gemini/AGENTS.md".source = ./AGENTS.md;
  };
}
