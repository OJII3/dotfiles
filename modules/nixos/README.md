# NixOS Modules - オプションベース設定システム

## 概要

このディレクトリには、`my.*` 名前空間でカスタマイズ可能な NixOS モジュールが含まれています。
従来の `imports` ベースの設定から、宣言的なオプションベースの設定への移行を進めています。

## ブランチ

- **ブランチ名**: `refactor/module-options`
- **ベース**: `main`

## コミット履歴

```
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
│   ├── audio.nix    # (空モジュール - default.nix に統合済み)
│   ├── bluetooth.nix
│   ├── ssh.nix
│   ├── boot/        # まだオプション化していない
│   ├── networking/  # まだオプション化していない
│   └── ...
├── desktop/
│   ├── default.nix  # my.desktop.* オプション定義
│   ├── hyprland.nix # (空モジュール - default.nix に統合済み)
│   ├── fonts.nix
│   ├── steam.nix
│   └── ...
├── hardware/
│   └── default.nix  # my.hardware.* オプション定義 (NEW)
└── server/
    ├── default.nix  # my.server.* オプション定義
    ├── autologin.nix # (空モジュール)
    └── adguard-home/
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
    ../../modules/nixos/core/networking/base.nix
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

    server = {
      enable = true;
      autologin.enable = true;
      adguardHome.enable = true;
    };

    hardware.gpu = "intel";
  };

  # ホスト固有設定
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen;
  # ...
}
```

### デスクトップ (例: Aglaea 移行後)

```nix
# hosts/Aglaea/nixos.nix (移行後のイメージ)
{ inputs, pkgs, ... }:
{
  imports = [
    ../../modules/nixos
    ../../modules/nixos/core/boot/systemd-boot.nix
    ../../modules/nixos/core/networking
    ../../modules/nixos/core/networking/networkmanager.nix
    ../../modules/nixos/core/virtualisation/podman.nix
    ./hardware-configuration.nix
  ];

  my = {
    core.enable = true;

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

  # ホスト固有設定
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen;
  boot.kernelParams = [ "amd_iommu=on" "mem_sleep_default=deep" ];
  # ...
}
```

## 残りの作業 (TODO)

### 未オプション化のモジュール

- [ ] `core/boot/` - systemd-boot, grub
- [ ] `core/networking/` - base, dns, networkmanager
- [ ] `core/virtualisation/` - podman, docker
- [ ] `core/power/` - laptop power management
- [ ] `desktop/greetd/` - tuigreet, autologin
- [ ] `desktop/bitwarden.nix`
- [ ] `desktop/peripheral/keyboard.nix`
- [ ] `server/gnome-keyring.nix`

### 未移行のホスト

- [ ] **Aglaea** - デスクトップ (AMD GPU, GNOME, ThinkPad)
- [ ] **Bronya** - デスクトップ (NVIDIA Prime, Hyprland)
- [ ] **Lingsha** - ラップトップ (AMD GPU, ThinkPad, 指紋認証)
- [ ] **Cyrene** - WSL
- [ ] **Welt** - Raspberry Pi 4

### 設計改善案

1. **Boot オプション追加**
   ```nix
   my.core.boot = {
     loader = "systemd-boot" | "grub";
     kernel = "zen" | "latest" | "lts";
   };
   ```

2. **Networking オプション追加**
   ```nix
   my.networking = {
     enable = true;
     tailscale.enable = true;
     networkManager.enable = true;
     warp.enable = false;
   };
   ```

3. **Virtualisation オプション追加**
   ```nix
   my.virtualisation = {
     podman.enable = true;
     docker.enable = false;
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
