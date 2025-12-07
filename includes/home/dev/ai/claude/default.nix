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
}
