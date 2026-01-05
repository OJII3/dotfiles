# ssh-client.nix
# SSH クライアント側（ローカル）で使用
# リモートの Claude Code から通知を受け取る notify-listener を起動
#
# このモジュールを import すると:
#   1. 全 SSH 接続に RemoteForward 19999:localhost:19999 が自動設定
#   2. notify-listener が systemd/launchd で自動起動
#   3. リモートの Claude Code 通知がローカルに転送される
{
  config,
  lib,
  pkgs,
  ...
}:
let
  port = "19999";
  scriptsDir = "${config.home.homeDirectory}/.claude/scripts";
  listenerScript = "${scriptsDir}/notify-listener.sh";
in
{
  # netcat パッケージを追加（リスナーに必要）
  home.packages = with pkgs; [
    netcat-gnu
  ];

  # Linux: systemd ユーザーサービス
  systemd.user.services.claude-notify-listener = lib.mkIf pkgs.stdenv.isLinux {
    Unit = {
      Description = "Claude Code Remote Notification Listener";
      After = [ "graphical-session.target" ];
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${listenerScript} ${port}";
      Restart = "always";
      RestartSec = 5;
      # 環境変数（notify-send が動作するために必要）
      Environment = [
        "DISPLAY=:0"
        "DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/%U/bus"
      ];
    };
  };

  # Darwin: launchd エージェント
  launchd.agents.claude-notify-listener = lib.mkIf pkgs.stdenv.isDarwin {
    enable = true;
    config = {
      Label = "com.claude.notify-listener";
      ProgramArguments = [
        "/bin/sh"
        listenerScript
        port
      ];
      RunAtLoad = true;
      KeepAlive = true;
      StandardOutPath = "${config.home.homeDirectory}/Library/Logs/claude-notify-listener.log";
      StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/claude-notify-listener.log";
    };
  };

  # SSH config: 全ホストに RemoteForward を設定
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "*" = {
        # デフォルト設定を明示的に記述
        serverAliveInterval = 60;
        serverAliveCountMax = 3;

        # Claude Code 通知転送
        remoteForwards = [
          {
            bind.port = 19999;
            host.address = "localhost";
            host.port = 19999;
          }
        ];
      };
    };
  };
}
