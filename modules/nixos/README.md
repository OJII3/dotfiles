# NixOS Modules - オプションベース設定システム

`dot.*` 名前空間で各ホストの設定を宣言的にカスタマイズするモジュール群。

## ディレクトリ構成

各カテゴリは「`options.nix`(オプション定義)+ 機能別ファイル(各 config 実装)+ `default.nix`(imports のみ)」の構成で統一されている。各実装ファイルは自身の `dot.*` オプションを `lib.mkIf` でゲートする。

```
modules/nixos/
├── default.nix      # 全サブモジュールを import するエントリポイント
├── core/
│   ├── default.nix  # imports のみ
│   ├── options.nix  # dot.core.* オプション定義
│   ├── base.nix     # ユーザーアカウント, Nix 設定
│   ├── audio.nix bluetooth.nix ssh.nix virtualisation.nix boot.nix
│   └── i18n.nix kdewallet.nix security.nix services.nix tools.nix uinput.nix
├── desktop/
│   ├── default.nix  # imports + base config
│   ├── options.nix  # dot.desktop.* オプション定義
│   └── gnome.nix hyprland.nix fonts.nix gaming.nix greetd.nix ...
├── hardware/default.nix    # dot.hardware.* (options + config)
├── networking/
│   ├── default.nix options.nix snmpd.nix warp.nix
└── server/
    └── default.nix zabbix.nix librenms.nix prometheus/ loki/ minecraft.nix
```

## 使用可能なオプション

### dot.core

| オプション | 型 | デフォルト | 説明 |
|-----------|-----|---------|------|
| `enable` | bool | `true` | コア設定(全ホスト共通のデフォルト) |
| `audio.enable` | bool | `true` | PipeWire オーディオ |
| `bluetooth.enable` | bool | `true` | Bluetooth サポート |
| `ssh.enable` | bool | `true` | OpenSSH サーバー |
| `user.name` | string | `"ojii3"` | ユーザー名 |
| `user.shell` | package | `pkgs.zsh` | デフォルトシェル |
| `user.extraGroups` | list | `[...]` | 追加グループ |
| `virtualisation.podman.enable` | bool | `false` | Podman コンテナランタイム |
| `virtualisation.podman.dockerCompat` | bool | `true` | Docker CLI 互換 (podman-docker) |
| `virtualisation.docker.enable` | bool | `false` | Docker コンテナランタイム |
| `virtualisation.docker.rootless.enable` | bool | `false` | ルートレス Docker |
| `boot.loader` | enum | `"none"` | `"systemd-boot"`, `"grub"`, `"none"` |
| `boot.efi.mountPoint` | string | `"/boot"` | EFI パーティションマウントポイント |
| `boot.grub.useOSProber` | bool | `true` | GRUB OS prober (デュアルブート検出) |

### dot.desktop

| オプション | 型 | デフォルト | 説明 |
|-----------|-----|---------|------|
| `enable` | bool | `false` | デスクトップ環境(Qt テーマ等の共通設定を含む) |
| `gnome.enable` | bool | `false` | GNOME デスクトップ (GDM + GNOME Shell)。`greetd.enable` と排他 |
| `hyprland.enable` | bool | `false` | Hyprland コンポジタ |
| `fonts.enable` | bool | `false` | カスタムフォント設定 |
| `flatpak.enable` | bool | `false` | Flatpak サポート |
| `sunshine.enable` | bool | `false` | Sunshine リモートデスクトップ |
| `waydroid.enable` | bool | `false` | Waydroid Android コンテナ |
| `keyd.enable` | bool | `false` | keyd キーリマッピング |
| `gaming.enable` | bool | `false` | ゲーミングサポート |
| `gaming.steam.enable` | bool | `true` | Steam (gaming 有効時) |
| `gaming.vr.enable` | bool | `false` | VR サポート (Monado) |
| `greetd.enable` | bool | `false` | greetd ログインマネージャー |
| `greetd.greeter` | enum | `"tuigreet"` | `"autologin"` または `"tuigreet"` |
| `greetd.user` | string | `"ojii3"` | ログインユーザー |
| `greetd.sessionCommand` | string | `"uwsm start..."` | セッション起動コマンド |
| `peripheral.keyboard.enable` | bool | `false` | Keychron キーボード udev ルール (VIA) |
| `androidDev.enable` | bool | `false` | Android 開発ツール (adb, Meta Quest udev) |
| `bitwarden.enable` | bool | `false` | Bitwarden Desktop |

### dot.hardware

| オプション | 型 | デフォルト | 説明 |
|-----------|-----|---------|------|
| `gpu` | enum | `null` | `"amd"`, `"nvidia"`, `"intel"`, `null` |
| `nvidia.prime.enable` | bool | `false` | NVIDIA Prime (ハイブリッド) |
| `nvidia.prime.offload.enable` | bool | `true` | Prime オフロードモード |
| `nvidia.prime.sync.enable` | bool | `false` | Prime シンクモード |
| `nvidia.prime.intelBusId` | string | `"PCI:0:2:0"` | Intel GPU PCI バス ID |
| `nvidia.prime.nvidiaBusId` | string | `"PCI:1:0:0"` | NVIDIA GPU PCI バス ID |
| `nvidia.open` | bool | `true` | オープンソース NVIDIA カーネルモジュール |
| `thinkpad.enable` | bool | `false` | ThinkPad 固有設定 (kernelParams + thinkfan) |
| `thinkpad.fanControl` | bool | `true` | thinkfan (thinkpad 有効時) |
| `laptop.enable` | bool | `false` | ラップトップ電源管理 |
| `laptop.power.tuned.enable` | bool | `true` | tuned 電源管理 (laptop 有効時) |
| `laptop.power.batteryProfile` | bool | `false` | バッテリー省電力プロファイル |
| `laptop.suspend.enable` | bool | `false` | サスペンド/ハイバネート設定 |
| `laptop.suspend.hibernateDelay` | string | `"600s"` | ハイバネート遅延時間 |

### dot.networking

| オプション | 型 | デフォルト | 説明 |
|-----------|-----|---------|------|
| `enable` | bool | `true` | ネットワーク設定 |
| `firewall.enable` | bool | `true` | ファイアウォール |
| `firewall.ros2.enable` | bool | `false` | ROS 2 UDP ポート (セキュリティ上デフォルト無効) |
| `kdeConnect.enable` | bool | `false` | KDE Connect ポート (1714-1764) |
| `tailscale.enable` | bool | `true` | Tailscale VPN |
| `dns.resolved.enable` | bool | `true` | systemd-resolved |
| `networkManager.enable` | bool | `false` | NetworkManager (サーバーは networkd) |
| `networkManager.wifi.randomizeMac` | bool | `true` | WiFi MAC アドレスランダム化 |
| `networkManager.wifi.powersave` | bool | `false` | WiFi 省電力モード |
| `warp.enable` | bool | `false` | Cloudflare WARP |
| `snmpd.enable` | bool | `false` | SNMP デーモン |

### dot.server

| オプション | 型 | デフォルト | 説明 |
|-----------|-----|---------|------|
| `enable` | bool | `false` | サーバー設定 |
| `autologin.enable` | bool | `false` | greetd 自動ログイン |
| `autologin.user` | string | `"ojii3"` | 自動ログインユーザー |
| `autologin.shell` | string | `"zsh"` | ログイン時のシェル |
| `adguardHome.enable` | bool | `false` | AdGuard Home DNS (resolved を無効化) |
| `gnomeKeyring.enable` | bool | `false` | GNOME Keyring (ヘッドレス用) |
| `zabbix.enable` / `librenms.enable` / `prometheus.enable` / `loki.enable` / `minecraft.enable` | bool | `false` | 各監視/ゲームサーバー |

## 使用例

### デスクトップ (Aglaea)

```nix
# hosts/Aglaea/nixos.nix
{ pkgs, ... }:
{
  imports = [
    ../../modules/nixos
    ./hardware-configuration.nix
  ];

  dot = {
    core.enable = true;
    core.boot.loader = "systemd-boot";
    core.virtualisation.podman.enable = true;

    networking.firewall.enable = false;
    networking.networkManager.enable = true;

    desktop = {
      enable = true;
      gnome.enable = true;
      fonts.enable = true;
      gaming = { enable = true; vr.enable = true; };
    };

    hardware = { gpu = "amd"; thinkpad.enable = true; };
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;
}
```

### ラップトップ / Hyprland (Bronya, Lingsha)

`gnome.enable` は付けず、`greetd` でログインする(GDM と排他)。

```nix
  dot.desktop = {
    enable = true;
    hyprland.enable = true;
    greetd = { enable = true; greeter = "tuigreet"; };
  };
```

### サーバー (Cipher)

```nix
  dot = {
    core = { enable = true; audio.enable = false; bluetooth.enable = false; };
    networking.networkManager.enable = false; # systemd-networkd を使用
    server = { enable = true; autologin.enable = true; adguardHome.enable = true; };
    hardware.gpu = "intel";
  };
```

## 動作確認コマンド

```bash
nix flake check                                  # 全体の構文/評価チェック
nixos-rebuild build --flake .#Aglaea --dry-run   # 特定ホストの評価
sudo nixos-rebuild switch --flake .#Aglaea       # 適用
```

ビルド対象の nixosConfigurations: **Aglaea / Bronya / Cipher / Cyrene(WSL)**
(Welt・Lingsha は home-manager のみ)

## メモ

- `dot.core.enable` はデフォルト `true`(全ホスト共通設定)。`dot.desktop.*` `dot.server.*` はデフォルト `false`。
- 条件付き設定は `lib.mkIf` / `lib.mkMerge` で実現。各実装ファイルは自身のオプションでゲートする。
- `dot.desktop.gnome.enable` と `dot.desktop.greetd.enable` は assertion で排他を保証している。
