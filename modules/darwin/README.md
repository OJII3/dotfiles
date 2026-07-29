# nix-darwin Modules

## 概要

macOS (nix-darwin) 用のモジュール。`dot.darwin.*` 名前空間でオプションベースの設定を提供。

## ディレクトリ構成

```
modules/darwin/
├── default.nix      # エントリポイント
├── core/
│   ├── default.nix  # core モジュールのエントリ
│   ├── options.nix  # dot.darwin.core.* オプション定義
│   ├── base.nix     # 基本設定 (pathsToLink)
│   ├── fonts.nix    # フォント設定 (Homebrew casks)
│   ├── homebrew.nix # Homebrew 共通設定 (enable, onActivation)
│   ├── tools.nix    # CLI ツール (vim, git, gnumake, python)
│   └── sops.nix     # sops-nix 設定
├── desktop/
│   ├── default.nix  # desktop モジュールのエントリ
│   ├── options.nix  # dot.darwin.desktop.* オプション定義
│   ├── base.nix     # 基本設定 (system.defaults, Touch ID)
│   ├── apps.nix     # GUI アプリ (Homebrew casks)
│   └── vr.nix       # VR 開発 (Meta XR Simulator)
├── networking/
│   ├── default.nix  # networking モジュールのエントリ
│   ├── options.nix  # dot.darwin.networking.* オプション定義
│   ├── base.nix     # 基本ネットワーク設定 (knownNetworkServices)
│   ├── tailscale.nix  # Tailscale (MAS + shell alias)
│   ├── openssh.nix  # OpenSSH サーバー
│   └── cloudflared.nix # Cloudflared CLI のみ
└── karabiner-ts/    # Karabiner-Elements 設定 (別管理)
```

## 使用方法

```nix
# hosts/<hostname>/darwin.nix
{ ... }:
{
  imports = [ ../../modules/darwin ];

  dot.darwin = {
    core = {
      enable = true;
      fonts.enable = true;
      sops.enable = true;
    };
    desktop = {
      enable = true;
      apps.enable = true;
      vr.enable = true;
    };
    networking = {
      enable = true;
      tailscale.enable = true;
      openssh.enable = true;
      cloudflared.enable = true;
    };
  };

  system.stateVersion = 6;
}
```

## 利用可能なオプション

### dot.darwin.core

| オプション | 説明 |
|-----------|------|
| `enable` | core 設定全体の有効化 |
| `fonts.enable` | Homebrew 経由のフォントインストール |
| `sops.enable` | sops-nix シークレット管理 |

### dot.darwin.desktop

| オプション | 説明 |
|-----------|------|
| `enable` | desktop 設定全体の有効化 (system.defaults 等) |
| `apps.enable` | GUI アプリ/casks のインストール |
| `vr.enable` | VR 開発環境 (Meta XR Simulator) |

### dot.darwin.networking

| オプション | 説明 |
|-----------|------|
| `enable` | ネットワーク設定全体の有効化 |
| `tailscale.enable` | Tailscale (MAS インストール + shell alias) |
| `openssh.enable` | OpenSSH サーバー |
| `cloudflared.enable` | Cloudflared CLI ツール |
