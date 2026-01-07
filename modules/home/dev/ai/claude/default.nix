{ config, lib, ... }:
let
  cfg = config.my.home.dev.ai;
in
{
  imports = [
    ./commands.nix
    ./skills.nix
    ./ssh-client.nix
  ];

  config = lib.mkIf cfg.claude.enable {
    programs.jq.enable = true;
    programs.claude-code = {
      enable = true;
      commandsDir = ./commands;
      skillsDir = ./skills;
    };

    home.file.".claude/settings.json".source = ./settings.json;
    home.file.".claude/CLAUDE.md".source = ./CLAUDE.md;
    home.file.".claude/scripts" = {
      source = ./scripts;
      executable = true;
    };
  };
}
