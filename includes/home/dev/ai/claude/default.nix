{ pkgs, ... }:
{
  imports = [
    ../.
    ./plugins.nix
    ./skills.nix
  ];
  programs.claude-code = {
    enable = true;
    commandsDir = ./commands;
  };

  # Claude Code設定ファイル
  home.file.".claude/settings.json".source = ./settings.json;
  home.file.".claude/CLAUDE.md".source = ./CLAUDE.md;
  home.file.".claude/scripts/notify.sh" = {
    source = ./scripts/notify.sh;
    executable = true;
  };
  home.file.".claude/skills/local" = {
    source = ./skills/local;
    recursive = true;
  };
}
