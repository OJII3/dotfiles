# Home Manager Modules

## 概要

Home Manager 用のモジュール。今後 `my.*` 名前空間でオプションベースの設定に移行予定。

## 現在のディレクトリ構成

```
modules/home/
├── default.nix
├── apps/           # アプリケーション設定
├── darwin/         # macOS 固有
├── desktop/        # デスクトップ環境
├── dev/            # 開発ツール
├── git/
├── gpg/
├── neovim/
├── ros2/
├── server/
├── terminal/
├── zsh/
└── *.nix           # 個別モジュール
```

## TODO: オプション化

nixos モジュールと同様のパターンで分割予定:

```
modules/home/
├── default.nix      # エントリポイント
├── options.nix      # my.home.* オプション定義
├── desktop/
│   ├── options.nix  # my.home.desktop.* オプション定義
│   └── *.nix        # config 実装
└── ...
```

### 想定オプション例

```nix
my.home = {
  desktop = {
    hyprland.enable = true;
    waybar.enable = true;
  };
  dev = {
    neovim.enable = true;
    vscode.enable = true;
  };
  terminal = {
    kitty.enable = true;
    zsh.enable = true;
  };
};
```
