{ pkgs, ... }:
{
  home.packages = with pkgs; [
    claude-code
    gomi
  ]
  ++ lib.lists.optionals (pkgs.stdenv.hostPlatform.isDarwin) [
    terminal-notifier
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
        "Bash(terminal-notifier *)"
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
      preferredNotifChannel = "macos";
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

  home.file.".claude/CLAUDE.md".text = ''
    # Claude Code 使用指示

    ## macOS通知について
    このシステムではmacOS通知が有効になっています。以下のような場面で通知を送ってください：

    ### 通知を送るタイミング
    - 長時間のタスク（5分以上）が完了した時
    - エラーが発生して修正が必要な時
    - ユーザーの確認や入力が必要な時
    - 重要な処理が完了した時（ビルド、テスト、デプロイなど）
    - 複数のファイルを変更した後

    ### 通知の送り方
    ```bash
    terminal-notifier -title "Claude Code" -message "タスクが完了しました" -sound default
    ```

    ### 通知例
    ```bash
    # タスク完了時
    terminal-notifier -title "Claude Code" -message "コードの修正が完了しました。確認をお願いします。" -sound default

    # エラー発生時
    terminal-notifier -title "Claude Code" -message "エラーが発生しました。修正が必要です。" -sound default

    # 長時間タスク完了時
    terminal-notifier -title "Claude Code" -message "ビルドが完了しました（所要時間: 8分）" -sound default
    ```

    ## 一般的な指示
    - コードの変更は段階的に行い、各段階で動作確認を推奨します
    - 重要な変更の前には必ずバックアップの確認を行ってください(gitの利用を推奨)
    - エラーログは詳細に確認し、根本原因を特定してください
  '';
}

