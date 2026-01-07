# NixOS Modules - オプションベース設定システム

## 概要

このディレクトリには、`my.*` 名前空間でカスタマイズ可能な NixOS モジュールが含まれています。
従来の `imports` ベースの設定から、宣言的なオプションベースの設定への移行を進めています。

## ブランチ

- **ブランチ名**: `refactor/module-options`
- **ベース**: `main`

## コミット履歴

```
xxxxxxx feat(nixos/networking): add networking options module
0318af2 refactor(hosts): migrate all hosts to options-based configuration
4525a4a refactor(hosts/Cipher): migrate to options-based configuration
76ef9b8 feat(nixos/server): convert to options-based module
6ee4a0e feat(nixos/hardware): add hardware options module
f563fb4 feat(nixos/desktop): convert to options-based module
1b56ef4 feat(nixos/core): convert to options-based module
682899d feat(nixos): add module options foundation
7eecc6c refactor: rename includes/ to modules/
```

## ディレクトリ構成

```
modules/nixos/
├── default.nix      # エントリポイント (全モジュールをインポート)
├── core/
│   ├── default.nix  # my.core.* オプション定義
│   ├── boot/        # まだオプション化していない
│   ├── virtualisation/  # まだオプション化していない
│   └── ...
├── desktop/
│   ├── default.nix  # my.desktop.* オプション定義
│   ├── greetd/      # まだオプション化していない
│   └── ...
├── hardware/
│   └── default.nix  # my.hardware.* オプション定義
├── networking/
│   └── default.nix  # my.networking.* オプション定義 (NEW)
└── server/
    └── default.nix  # my.server.* オプション定義
```

## 使用可能なオプション

### my.core

| オプション | 型 | デフォルト | 説明 |
|-----------|-----|---------|------|
| `enable` | bool | `true` | コア設定を有効化 |
| `audio.enable` | bool | `true` | PipeWire オーディオ |
| `bluetooth.enable` | bool | `true` | Bluetooth サポート |
| `ssh.enable` | bool | `true` | OpenSSH サーバー |
| `user.name` | string | `"ojii3"` | ユーザー名 |
| `user.shell` | package | `pkgs.zsh` | デフォルトシェル |
| `user.extraGroups` | list | `[...]` | 追加グループ |

### my.desktop

| オプション | 型 | デフォルト | 説明 |
|-----------|-----|---------|------|
| `enable` | bool | `false` | デスクトップ環境を有効化 |
| `hyprland.enable` | bool | `false` | Hyprland コンポジタ |
| `fonts.enable` | bool | `false` | カスタムフォント設定 |
| `flatpak.enable` | bool | `false` | Flatpak サポート |
| `sunshine.enable` | bool | `false` | Sunshine リモートデスクトップ |
| `waydroid.enable` | bool | `false` | Waydroid Android コンテナ |
| `keyd.enable` | bool | `false` | keyd キーリマッピング |
| `gaming.enable` | bool | `false` | ゲーミングサポート |
| `gaming.steam.enable` | bool | `true` | Steam (gaming が有効時) |
| `gaming.vr.enable` | bool | `false` | VR サポート (Monado) |

### my.hardware

| オプション | 型 | デフォルト | 説明 |
|-----------|-----|---------|------|
| `gpu` | enum | `null` | GPU タイプ: `"amd"`, `"nvidia"`, `"intel"`, `null` |
| `nvidia.prime.enable` | bool | `false` | NVIDIA Prime (ハイブリッド) |
| `nvidia.prime.offload.enable` | bool | `true` | Prime オフロードモード |
| `nvidia.prime.sync.enable` | bool | `false` | Prime シンクモード |
| `nvidia.prime.intelBusId` | string | `"PCI:0:2:0"` | Intel GPU PCI バス ID |
| `nvidia.prime.nvidiaBusId` | string | `"PCI:1:0:0"` | NVIDIA GPU PCI バス ID |
| `nvidia.open` | bool | `true` | オープンソース NVIDIA カーネルモジュール |
| `thinkpad.enable` | bool | `false` | ThinkPad 固有設定 (thinkfan) |
| `laptop.enable` | bool | `false` | ラップトップ電源管理 |

### my.networking

| オプション | 型 | デフォルト | 説明 |
|-----------|-----|---------|------|
| `enable` | bool | `true` | ネットワーク設定を有効化 |
| `firewall.enable` | bool | `true` | ファイアウォール有効化 |
| `firewall.kdeConnect.enable` | bool | `true` | KDE Connect ポート (1714-1764) |
| `firewall.ros2.enable` | bool | `false` | ROS 2 UDP ポート (セキュリティ上デフォルト無効) |
| `tailscale.enable` | bool | `true` | Tailscale VPN |
| `dns.resolved.enable` | bool | `true` | systemd-resolved (DNS over TLS) |
| `networkManager.enable` | bool | `false` | NetworkManager (サーバーは networkd 使用) |
| `networkManager.wifi.randomizeMac` | bool | `true` | WiFi MAC アドレスランダム化 |
| `networkManager.wifi.powersave` | bool | `false` | WiFi 省電力モード |
| `warp.enable` | bool | `false` | Cloudflare WARP |

### my.server

| オプション | 型 | デフォルト | 説明 |
|-----------|-----|---------|------|
| `enable` | bool | `false` | サーバー設定を有効化 |
| `autologin.enable` | bool | `false` | greetd 自動ログイン |
| `autologin.user` | string | `"ojii3"` | 自動ログインユーザー |
| `autologin.shell` | string | `"zsh"` | ログイン時のシェル |
| `adguardHome.enable` | bool | `false` | AdGuard Home DNS |

## 使用例

### サーバー (Cipher)

```nix
# hosts/Cipher/nixos.nix
{ inputs, pkgs, ... }:
{
  imports = [
    ../../modules/nixos
    ../../modules/nixos/core/boot/systemd-boot.nix
    ../../modules/nixos/core/virtualisation/podman.nix
    ./hardware-configuration.nix
  ];

  my = {
    core = {
      enable = true;
      audio.enable = false;      # ヘッドレスサーバー
      bluetooth.enable = false;
      ssh.enable = true;
    };

    networking = {
      # サーバーは systemd-networkd を使用
      networkManager.enable = false;
    };

    server = {
      enable = true;
      autologin.enable = true;
      adguardHome.enable = true;  # resolved は自動無効化
    };

    hardware.gpu = "intel";
  };

  # Static IP (ホスト固有)
  networking.useNetworkd = true;
  systemd.network.networks."10-lan" = { ... };

  boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen;
}
```

### デスクトップ (Aglaea)

```nix
# hosts/Aglaea/nixos.nix
{ pkgs, ... }:
{
  imports = [
    ../../modules/nixos
    ../../modules/nixos/core/boot/systemd-boot.nix
    ../../modules/nixos/core/virtualisation/podman.nix
    ./hardware-configuration.nix
  ];

  my = {
    core.enable = true;

    networking = {
      networkManager.enable = true;
      firewall.ros2.enable = true;
    };

    desktop = {
      enable = true;
      fonts.enable = true;
      keyd.enable = true;
      sunshine.enable = true;
      waydroid.enable = true;
      gaming = {
        enable = true;
        vr.enable = true;
      };
    };

    hardware = {
      gpu = "amd";
      thinkpad.enable = true;
    };
  };

  # GNOME デスクトップ (まだオプション化していない)
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen;
}
```

### ラップトップ (Lingsha)

```nix
# hosts/Lingsha/nixos.nix
{ pkgs, ... }:
{
  imports = [
    ../../modules/nixos
    # ... その他の未オプション化モジュール
  ];

  my = {
    core.enable = true;

    networking = {
      networkManager.enable = true;
      firewall.ros2.enable = true;
      warp.enable = true;  # Cloudflare WARP
    };

    desktop = {
      enable = true;
      fonts.enable = true;
      sunshine.enable = true;
      waydroid.enable = true;
    };

    hardware = {
      gpu = "amd";
      thinkpad.enable = true;
      laptop.enable = true;
    };
  };

  # 指紋認証
  services.fprintd.enable = true;
}
```

## 残りの作業 (TODO)

### 未オプション化のモジュール

- [ ] `core/boot/` - systemd-boot, grub
- [x] ~~`core/networking/` - base, dns, networkmanager~~ → `my.networking.*`
- [ ] `core/virtualisation/` - podman, docker
- [ ] `core/power/` - laptop power management
- [ ] `desktop/greetd/` - tuigreet, autologin
- [ ] `desktop/bitwarden.nix`
- [ ] `desktop/peripheral/keyboard.nix`
- [ ] `server/gnome-keyring.nix`

### ホスト移行状況

- [x] **Aglaea** - デスクトップ (AMD GPU, GNOME, ThinkPad) ✅
- [x] **Bronya** - デスクトップ (NVIDIA Prime, Hyprland) ✅
- [x] **Cipher** - サーバー (Intel GPU, AdGuard Home) ✅
- [x] **Lingsha** - ラップトップ (AMD GPU, ThinkPad, 指紋認証) ✅
- [ ] **Welt** - Raspberry Pi 4 (部分移行: my.core のみ使用)
- [ ] **Cyrene** - WSL (modules/nixos 未使用)

### 設計改善案

1. **Boot オプション追加**
   ```nix
   my.boot = {
     loader = "systemd-boot" | "grub";
     kernel = "zen" | "latest" | "lts";
   };
   ```

2. **Virtualisation オプション追加**
   ```nix
   my.virtualisation = {
     podman.enable = true;
     docker.enable = false;
   };
   ```

3. **Greetd オプション追加**
   ```nix
   my.desktop.greetd = {
     enable = true;
     greeter = "tuigreet" | "autologin";
   };
   ```

## 参考リソース

- [NixOS & Flakes Book](https://nixos-and-flakes.thiscute.world/)
- [NixOS Wiki - NixOS modules](https://wiki.nixos.org/wiki/NixOS_modules)
- [NotAShelf/nyx](https://github.com/NotAShelf/nyx) - 参考実装
- [fufexan/dotfiles](https://github.com/fufexan/dotfiles) - 参考実装

## 動作確認コマンド

```bash
# 構文チェック
nix flake check

# 特定ホストのビルド (dry-run)
nixos-rebuild build --flake .#Cipher --dry-run

# 実際のビルド
nixos-rebuild build --flake .#Cipher

# 適用
sudo nixos-rebuild switch --flake .#Cipher
```

## メモ

- `my.core.enable` はデフォルト `true` (後方互換性のため)
- `my.desktop.*`, `my.server.*` はデフォルト `false`
- 空モジュール (例: `audio.nix`) は既存の imports を壊さないために残している
- `lib.mkIf` と `lib.mkMerge` を使って条件付き設定を実現
