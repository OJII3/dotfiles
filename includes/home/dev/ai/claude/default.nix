{ pkgs, ... }:
{
  imports = [
    ../.
  ];
  home.packages = with pkgs; [
    claude-code
  ];

  # Claude Code設定ファイル
  home.file.".claude/settings.json".source = ./settings.json;
  home.file.".claude/CLAUDE.md".source = ./CLAUDE.md;
  home.file.".claude/scripts/notify.sh" = {
    source = ./scripts/notify.sh;
    executable = true;
  };
  home.file.".claude/commands" = {
    source = ./commands;
    recursive = true;
  };
}
