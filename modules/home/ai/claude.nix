{ pkgs, ... }:
{
  home.packages = with pkgs; [
    claude-code
    gomi
  ];
  # Claude Code設定ファイル
  home.file.".claude/settings.json".text = builtins.toJSON {
    permissions = {
      allow = [
        "Bash(npm run lint)"
        "Bash(npm run test:*)"
        "Bash(git status)"
        "Bash(git diff)"
        "Bash(git add *)"
        "Bash(git commit *)"
        "Bash(git push)"
        "Bash(git pull)"
        "Bash(ls *)"
        "Bash(find *)"
        "Bash(grep *)"
        "Bash(gomi *)"
        "Read(~/.zshrc)"
        "Read(~/.bashrc)"
        "Read(~/.vimrc)"
        "Read(~/.config/*)"
        "Read(package.json)"
        "Read(tsconfig.json)"
        "Read(*.md)"
        "Read(*.txt)"
        "Read(*.json)"
        "Read(*.yml)"
        "Read(*.yaml)"
        "Read(*.toml)"
        "Read(Cargo.toml)"
        "Read(pyproject.toml)"
        "Read(requirements.txt)"
        "Read(Dockerfile)"
        "Read(docker-compose.yml)"
        "Read(.env*)"
        "Read(*.nix)"
        "Write(*.md)"
        "Write(*.txt)"
        "Write(*.json)"
        "Write(*.js)"
        "Write(*.ts)"
        "Write(*.tsx)"
        "Write(*.jsx)"
        "Write(*.py)"
        "Write(*.rs)"
        "Write(*.go)"
        "Write(*.java)"
        "Write(*.cpp)"
        "Write(*.c)"
        "Write(*.h)"
        "Write(*.nix)"
      ];
      deny = [
        "Bash(rm -rf *)"
        "Bash(sudo *)"
        "Bash(curl *)"
        "Bash(wget *)"
        "Write(/etc/*)"
        "Write(/usr/*)"
        "Write(/bin/*)"
        "Write(/sbin/*)"
      ];
      preferredNotifChannel = "iterm2_with_bell";
    };

    env = {
      CLAUDE_CODE_ENABLE_TELEMETRY = "0";
      DISABLE_TELEMETRY = "1";
      DISABLE_ERROR_REPORTING = "1";
      DISABLE_AUTOUPDATER = "1";
    };

    # チャット記録の保持期間を短く設定
    cleanupPeriodDays = 7;

    # co-authored-by署名を含める
    includeCoAuthoredBy = true;
  };
}

