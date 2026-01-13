{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dot.home.dev.ai;
in
{
  config = lib.mkIf cfg.codex.enable {
    home.packages = with pkgs; [
      codex
    ];

    home.file.".codex/AGENTS.md".source = ./AGENTS.md;
  };
}
