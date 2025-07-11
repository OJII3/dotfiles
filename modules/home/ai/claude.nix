{ pkgs, ... }:
{
  home.packages = with pkgs; [
    claude-code
    gomi
  ]
  ++ lib.lists.optionals (pkgs.stdenv.hostPlatform.isDarwin) [
    terminal-notifier
  ]
  ++ lib.lists.optionals (pkgs.stdenv.hostPlatform.isLinux) [
    libnotify
  ];

  # Claude Code設定ファイル
  home.file.".claude/settings.json".source = ./settings.json;
  home.file.".claude/CLAUDE.md".source = ./CLAUDE.md;
}
