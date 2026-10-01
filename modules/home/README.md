# Home Manager Modules

## 概要

Home Manager 用のモジュール。`dot.home.*` 名前空間でオプションベースの設定を提供。

## ディレクトリ構成

```
modules/home/
├── default.nix      # エントリポイント
├── options.nix      # dot.home.* オプション定義
├── darwin/
│   ├── default.nix  # darwin エントリポイント
│   ├── options.nix  # dot.home.darwin.* オプション定義
│   └── */           # aerospace, jankyborders, skhd
├── desktop/
│   ├── default.nix  # desktop エントリポイント
│   ├── options.nix  # dot.home.desktop.* オプション定義
│   └── */           # 各モジュール (hyprland, waybar, gnome, etc.)
├── terminal/
│   ├── default.nix
│   ├── options.nix
│   └── */           # ghostty, kitty, wezterm
├── ai/
│   ├── default.nix
│   ├── options.nix
│   └── */           # claude, codex, chatgpt, opencode, antigravity, t3code
├── dev/
│   ├── default.nix
│   ├── options.nix
│   └── */           # jetbrains, vscode, etc.
├── apps/
│   ├── common.nix   # クロスプラットフォームアプリ (macOS & Linux)
│   └── linux/       # Linux 専用アプリ
└── *.nix            # ルートレベルモジュール (zsh, neovim, git, etc.)
```

## 使い方

ホストの `home-manager.nix` で `dot.home.*` オプションを設定:

```nix
{ ... }:
{
  imports = [
    ../../modules/home
  ];

  dot.home = {
    # Shell & Editor
    zsh.enable = true;
    neovim.enable = true;
    git.enable = true;
    gpg = {
      enable = true;
      pinentryPackage = "gnome3";  # "tty", "qt", "gnome3"
    };
    direnv.enable = true;
    sops.enable = true;

    # Desktop
    desktop = {
      enable = true;
      hyprland.enable = true;  # or gnome.enable = true;
      waybar.enable = true;
      anyrun.enable = true;
      swaync.enable = true;
      wlogout.enable = true;
      fcitx5.enable = true;
      theme.enable = true;
      browser.vivaldi.enable = true;
    };

    # Terminal
    terminal = {
      enable = true;
      ghostty.enable = true;
      # kitty.enable = true;
    };

    # Development
    dev = {
      enable = true;
      vscode.enable = true;
      jetbrains.enable = true;
      mise.enable = true;
    };

    # AI
    ai = {
      enable = true;
      claude.enable = true;
      codex.enable = true;
      chatgpt.enable = true;
      opencode.enable = true;
      agy.enable = true;
      t3code = {
        enable = true;
        backgroundService.enable = true;
      };
    };

    # Apps
    apps = {
      common.enable = true;    # クロスプラットフォームアプリ (JetBrains Toolbox, Slack 等)
      linux = {
        common.enable = true;    # 一般的な Linux デスクトップアプリ
        hyprland.enable = true;  # Hyprland 専用アプリ
        gnome.enable = true;     # GNOME 専用アプリ
      };
    };

    # macOS (Darwin)
    darwin = {
      aerospace.enable = true;    # Aerospace window manager
      jankyborders.enable = true; # JankyBorders
      skhd.enable = true;         # skhd hotkeys
    };

    # Other
    bitwarden.enable = true;
    network.enable = true;
    kdewallet.enable = true;
    kdeconnect.enable = true;
    gnomeKeyring.enable = true;
    vr.enable = true;
    ros2.enable = true;
  };
}
```

## 利用可能なオプション

### ルートレベル (`dot.home.*`)

| オプション | 説明 |
|-----------|------|
| `zsh.enable` | Zsh シェル設定 |
| `neovim.enable` | Neovim エディタ |
| `git.enable` | Git 設定 |
| `gpg.enable` | GPG 設定 |
| `gpg.pinentryPackage` | Pinentry タイプ: `"tty"`, `"qt"`, `"gnome3"` |
| `direnv.enable` | Direnv 統合 |
| `sops.enable` | Sops シークレット管理 |
| `bitwarden.enable` | Bitwarden パスワードマネージャー |
| `network.enable` | ネットワークユーティリティ |
| `kdewallet.enable` | KDE wallet 統合 |
| `kdeconnect.enable` | KDE Connect |
| `gnomeKeyring.enable` | GNOME Keyring |
| `vr.enable` | VR サポート (OpenComposite) |
| `ros2.enable` | ROS2 ロボティクスフレームワーク |

### Apps (`dot.home.apps.*`)

| オプション | 説明 |
|-----------|------|
| `common.enable` | クロスプラットフォームアプリ (JetBrains Toolbox, Slack, Postman 等) |
| `linux.common.enable` | 一般的な Linux デスクトップアプリ (Discord, Blender, VLC 等) |
| `linux.hyprland.enable` | Hyprland 専用アプリ (Nautilus, Evince 等) |
| `linux.gnome.enable` | GNOME 専用アプリ (Firefox 等) |

### Desktop (`dot.home.desktop.*`)

| オプション | 説明 |
|-----------|------|
| `enable` | デスクトップ環境 (ベース) |
| `hyprland.enable` | Hyprland コンポジター |
| `gnome.enable` | GNOME デスクトップ |
| `power.serverLike` | GNOME ユーザー設定で蓋閉じ動作とアイドル時スリープを無効化。NixOS 側でも `dot.desktop.power.serverLike` を有効化 |
| `waybar.enable` | Waybar ステータスバー |
| `anyrun.enable` | Anyrun ランチャー |
| `swaync.enable` | SwayNC 通知センター |
| `wlogout.enable` | Wlogout ログアウトメニュー |
| `fcitx5.enable` | Fcitx5 入力メソッド |
| `keyd.enable` | Keyd キーリマッピング |
| `xremap.enable` | Xremap キーリマッピング |
| `theme.enable` | デスクトップテーマ |
| `browser.vivaldi.enable` | Vivaldi ブラウザ |

### Terminal (`dot.home.terminal.*`)

| オプション | 説明 |
|-----------|------|
| `enable` | ターミナル (ベース: フォント等) |
| `ghostty.enable` | Ghostty ターミナル |
| `kitty.enable` | Kitty ターミナル |
| `wezterm.enable` | WezTerm ターミナル |

### Dev (`dot.home.dev.*`)

| オプション | 説明 |
|-----------|------|
| `enable` | 開発ツール (ベース: ユーティリティ) |
| `vscode.enable` | VS Code |
| `jetbrains.enable` | JetBrains IDE 設定 |
| `mise.enable` | mise バージョンマネージャー |

### AI (`dot.home.ai.*`)

| オプション | 説明 |
|-----------|------|
| `enable` | AI アシスタント共通設定 |
| `claude.enable` | Claude Code |
| `codex.enable` | Codex |
| `chatgpt.enable` | ChatGPT Desktop |
| `opencode.enable` | OpenCode |
| `agy.enable` | Antigravity |
| `t3code.enable` | T3 Code CLI and desktop app |
| `t3code.backgroundService.enable` | T3 Code background service |
| `t3code.backgroundService.host` | Background service bind address (default `127.0.0.1`) |

T3 Code は `llm-agents.nix` から CLI とデスクトップアプリを導入します。`t3code.backgroundService.enable` は macOS で LaunchAgent、Linux で systemd ユーザーサービスを作ります。サービスはデスクトップ内蔵サーバーと状態を共有しないよう `~/.t3-service` を使い、標準では `127.0.0.1:3773` で待ち受けます。Cipher では Cloudflare WARP インターフェースからの接続用に `3773/tcp` を許可します。サービス側の接続設定では `T3CODE_HOME="$HOME/.t3-service" t3 connect` を使ってください。起動サービスは Home Manager が管理するため、CLI 側のバックグラウンドサービス登録は選ばないでください。

### Darwin (`dot.home.darwin.*`)

| オプション | 説明 |
|-----------|------|
| `aerospace.enable` | Aerospace ウィンドウマネージャー |
| `jankyborders.enable` | JankyBorders ウィンドウボーダー |
| `skhd.enable` | skhd ホットキーデーモン |
