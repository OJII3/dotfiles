# nix-darwin Modules

## 概要

macOS (nix-darwin) 用のモジュール。`my.darwin.*` 名前空間でオプションベースの設定を提供。

## ディレクトリ構成

```
modules/darwin/
├── default.nix      # エントリポイント
├── core/
│   ├── default.nix  # core モジュールのエントリ
│   ├── options.nix  # my.darwin.core.* オプション定義
│   ├── base.nix     # 基本設定 (nix, pathsToLink)
│   ├── fonts.nix    # フォント設定 (Homebrew casks)
│   ├── networking.nix # ネットワーク設定 (Tailscale, SSH)
│   └── sops.nix     # sops-nix 設定
├── desktop/
│   ├── default.nix  # desktop モジュールのエントリ
│   ├── options.nix  # my.darwin.desktop.* オプション定義
│   ├── base.nix     # 基本設定 (system.defaults, Touch ID)
│   ├── apps.nix     # Homebrew アプリ
│   └── vr.nix       # VR 開発 (Meta XR Simulator)
└── karabiner-ts/    # Karabiner-Elements 設定 (別管理)
```

## 使用方法

```nix
# hosts/<hostname>/darwin.nix
{ ... }:
{
  imports = [ ../../modules/darwin ];

  my.darwin = {
    core = {
      enable = true;
      fonts.enable = true;
      networking.enable = true;
      sops.enable = true;
    };
    desktop = {
      enable = true;
      apps.enable = true;
      vr.enable = true;
    };
  };

  system.stateVersion = 6;
}
```

## 利用可能なオプション

### my.darwin.core

| オプション | 説明 |
|-----------|------|
| `enable` | core 設定全体の有効化 |
| `fonts.enable` | Homebrew 経由のフォントインストール |
| `networking.enable` | ネットワーク設定 (Tailscale, SSH) |
| `sops.enable` | sops-nix シークレット管理 |

### my.darwin.desktop

| オプション | 説明 |
|-----------|------|
| `enable` | desktop 設定全体の有効化 (system.defaults 等) |
| `apps.enable` | Homebrew アプリ/casks のインストール |
| `vr.enable` | VR 開発環境 (Meta XR Simulator) |
