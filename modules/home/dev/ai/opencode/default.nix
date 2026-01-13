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
  config = lib.mkIf cfg.opencode.enable {
    programs.opencode = {
      enable = true;
      rules = ./AGENTS.md;
      commands = {
        plan = ./commands/plan.md;
      };
    };
  };
}
