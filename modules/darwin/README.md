# nix-darwin Modules

## 概要

macOS (nix-darwin) 用のモジュール。今後 `my.*` 名前空間でオプションベースの設定に移行予定。

## 現在のディレクトリ構成

```
modules/darwin/
├── core/           # システム基本設定
├── desktop/        # デスクトップ環境
└── karabiner-ts/   # Karabiner-Elements 設定
```

## TODO: オプション化

nixos モジュールと同様のパターンで分割予定:

```
modules/darwin/
├── default.nix      # エントリポイント
├── options.nix      # my.darwin.* オプション定義
├── core/
│   ├── options.nix
│   └── *.nix
└── desktop/
    ├── options.nix
    └── *.nix
```

### 想定オプション例

```nix
my.darwin = {
  core = {
    enable = true;
    homebrew.enable = true;
  };
  desktop = {
    yabai.enable = false;
    karabiner.enable = true;
  };
};
```
