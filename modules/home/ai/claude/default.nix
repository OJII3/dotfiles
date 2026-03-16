{
  config,
  lib,
  pkgs,
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
      package = pkgs.claude-code-bin;
    };

    programs.zsh.zsh-abbr.abbreviations = {
      "c" = "claude";
    };

    home.file.".local/bin/claude".source = "${config.programs.claude-code.package}/bin/claude";
    home.file.".claude/settings.json".source = ./settings.json;
    home.file.".claude/CLAUDE.md".source = ./CLAUDE.md;
  };
}
