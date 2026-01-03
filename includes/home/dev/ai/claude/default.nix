{
  imports = [
    ../common.nix
    ./commands.nix
    ./plugins.nix
    ./skills.nix
  ];
  programs.jq.enable = true;
  programs.claude-code = {
    enable = true;
    commandsDir = ./commands;
    skillsDir = ./skills;
  };

  # Claude Code設定ファイル
  home.file.".claude/settings.json".source = ./settings.json;
  home.file.".claude/CLAUDE.md".source = ./CLAUDE.md;
  home.file.".claude/scripts" = {
    source = ./scripts;
    executable = true;
  };
}
