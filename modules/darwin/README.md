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
│   ├── vr.nix       # VR 開発 (Meta XR Simulator)
│   └── hammerspoon.nix # Hammerspoon + CapsLock→Control リマップ (キーリマップ)
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
      hammerspoon.enable = true;
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
| `hammerspoon.enable` | Hammerspoon + CapsLock→Control リマップ (キーリマップ) |

`hammerspoon.enable` は tap/hold 判定のスクリプト (`~/.hammerspoon/init.lua`) を
Home Manager 側の `dot.home.desktop.hammerspoon.enable` とセットで有効化する。
初回のみ System Settings > Privacy & Security > Accessibility で
Hammerspoon に権限を付与する必要がある (Karabiner 系のドライバや
システム拡張の承認は不要)。

割り当てているキー:

| キー | tap | hold |
|------|-----|------|
| CapsLock (OS レベルで Control にリマップ済み) | Esc | Ctrl |
| Space | Space | Command |

Space は通常キーなので、高速タイピングでの押し重なり (例: `the cat` の空白と
次の文字) を Cmd と誤認しないよう、200ms 以上押し続けたときだけ Cmd として
振る舞う。副作用として space 長押しによるスペースの連打 (オートリピート) は
使えなくなる。ゲーム等でジャンプができなくなるアプリは `init.lua` 内の
`SPACE_EXCLUDED_APPS` で除外する (既定は Minecraft)。

### dot.darwin.networking

| オプション | 説明 |
|-----------|------|
| `enable` | ネットワーク設定全体の有効化 |
| `tailscale.enable` | Tailscale (MAS インストール + shell alias) |
| `openssh.enable` | OpenSSH サーバー |
| `cloudflared.enable` | Cloudflared CLI ツール |
