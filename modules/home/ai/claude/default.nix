{
  config,
  lib,
  ...
}:
let
  cfg = config.dot.home.ai;
in
{
  imports = [
    ./commands.nix
  ];

  config = lib.mkIf cfg.claude.enable {
    programs.jq.enable = true;
    programs.claude-code = {
      enable = true;
      commandsDir = ./commands;
    };

    home.file.".claude/settings.json".source = ./settings.json;
    home.file.".claude/CLAUDE.md".source = ./CLAUDE.md;
    home.file.".claude/scripts" = {
      source = ./scripts;
      executable = true;
    };
  };
}
