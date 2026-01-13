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
      settings = import ./settings.nix;
      rules = ./AGENTS.md;
      commands = {
        plan = ./commands/plan.md;
      };
    };
  };
}
