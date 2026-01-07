# Home Manager Modules

## 概要

Home Manager 用のモジュール。`my.home.*` 名前空間でオプションベースの設定を提供。

## ディレクトリ構成

```
modules/home/
├── default.nix      # エントリポイント
├── options.nix      # my.home.* オプション定義
├── desktop/
│   ├── default.nix  # desktop エントリポイント
│   ├── options.nix  # my.home.desktop.* オプション定義
│   └── */           # 各モジュール (hyprland, waybar, gnome, etc.)
├── terminal/
│   ├── default.nix
│   ├── options.nix
│   └── */           # ghostty, kitty, wezterm
├── dev/
│   ├── default.nix
│   ├── options.nix
│   └── */           # ai, jetbrains, vscode, etc.
└── *.nix            # ルートレベルモジュール (zsh, neovim, git, etc.)
```

## 使い方

ホストの `home-manager.nix` で `my.home.*` オプションを設定:

```nix
{ ... }:
{
  imports = [
    ../../modules/home
  ];

  my.home = {
    # Shell & Editor
    zsh.enable = true;
    neovim.enable = true;
    git.enable = true;
    gpg.enable = true;
    direnv.enable = true;
    sops.enable = true;

    # Desktop
    desktop = {
      enable = true;
      hyprland.enable = true;  # or gnome.enable = true;
      waybar.enable = true;
      anyrun.enable = true;
      swaync.enable = true;
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
      ai = {
        enable = true;
        claude.enable = true;
        codex.enable = true;
        gemini.enable = true;
      };
    };

    # Other
    bitwarden.enable = true;
    network.enable = true;
    kdewallet.enable = true;
    ros2.enable = true;
  };
}
```

## 利用可能なオプション

### ルートレベル (`my.home.*`)

| オプション | 説明 |
|-----------|------|
| `zsh.enable` | Zsh シェル設定 |
| `neovim.enable` | Neovim エディタ |
| `git.enable` | Git 設定 |
| `gpg.enable` | GPG 設定 |
| `gpg.console` | コンソールモード (pinentry-tty) |
| `direnv.enable` | Direnv 統合 |
| `sops.enable` | Sops シークレット管理 |
| `bitwarden.enable` | Bitwarden パスワードマネージャー |
| `network.enable` | ネットワークユーティリティ |
| `kdewallet.enable` | KDE wallet 統合 |
| `ros2.enable` | ROS2 ロボティクスフレームワーク |

### Desktop (`my.home.desktop.*`)

| オプション | 説明 |
|-----------|------|
| `enable` | デスクトップ環境 (ベース) |
| `hyprland.enable` | Hyprland コンポジター |
| `gnome.enable` | GNOME デスクトップ |
| `waybar.enable` | Waybar ステータスバー |
| `anyrun.enable` | Anyrun ランチャー |
| `swaync.enable` | SwayNC 通知センター |
| `wlogout.enable` | Wlogout ログアウトメニュー |
| `fcitx5.enable` | Fcitx5 入力メソッド |
| `keyd.enable` | Keyd キーリマッピング |
| `xremap.enable` | Xremap キーリマッピング |
| `theme.enable` | デスクトップテーマ |
| `browser.vivaldi.enable` | Vivaldi ブラウザ |

### Terminal (`my.home.terminal.*`)

| オプション | 説明 |
|-----------|------|
| `enable` | ターミナル (ベース: フォント等) |
| `ghostty.enable` | Ghostty ターミナル |
| `kitty.enable` | Kitty ターミナル |
| `wezterm.enable` | WezTerm ターミナル |

### Dev (`my.home.dev.*`)

| オプション | 説明 |
|-----------|------|
| `enable` | 開発ツール (ベース: ユーティリティ) |
| `vscode.enable` | VS Code |
| `jetbrains.enable` | JetBrains IDE 設定 |
| `mise.enable` | mise バージョンマネージャー |
| `ai.enable` | AI アシスタント共通パッケージ |
| `ai.claude.enable` | Claude Code |
| `ai.codex.enable` | Codex |
| `ai.gemini.enable` | Gemini |
