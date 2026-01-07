# Vivaldi 設定管理

Vivaldiの同期できない設定をdotfilesで管理するモジュール。

## 管理対象

| 項目 | 説明 |
|------|------|
| `intl` | 言語設定 |
| `default_search_provider` | デフォルト検索エンジン |
| `vivaldi.actions` | キーボードショートカット |
| `vivaldi.address_bar` | アドレスバー設定 |
| `vivaldi.appearance` | 外観設定 |
| `vivaldi.dashboard` | ダッシュボード/ウィジェット |
| `vivaldi.panels` | パネル配置 |
| `vivaldi.startpage` | スタートページ設定 |
| `vivaldi.status_bar` | ステータスバー |
| `vivaldi.tabs` | タブ設定 |
| `vivaldi.theme` | 現在のテーマ |
| `vivaldi.themes` | カスタムテーマ一覧 |
| `vivaldi.toolbars` | ツールバー配置 |
| `Bookmarks` | ブックマーク |
| `themes/` | ユーザーテーマの背景画像 |

## 使い方

### 設定を変更したら（dotfilesに保存）

```bash
# Vivaldiで設定を変更した後
./export.sh
git add -A && git commit -m "update vivaldi settings"
```

### 別マシンで適用

```bash
# Vivaldiを閉じた状態で
home-manager switch --flake .#ojii3@<hostname>
```

## 動作の仕組み

1. `home-manager switch` 時に activation script が実行される
2. Vivaldiが起動中でなければ:
   - `Preferences` に設定をマージ (jq)
   - `Bookmarks` を復元
   - テーマ画像を `VivaldiThumbnails/` にコピー
3. Vivaldiが起動中の場合はスキップ（次回適用）

## 管理できないもの

- システムテーマのカスタム背景画像 (`local-image/` - LevelDB内)
- 拡張機能の個別設定
- Sync対応項目（パスワード等）

## ファイル構成

```
vivaldi/
├── default.nix           # Nixモジュール
├── export.sh             # エクスポートスクリプト
├── vivaldi-settings.json # 抽出した設定
├── Bookmarks             # ブックマーク
├── themes/               # ユーザーテーマ画像
│   └── *.jpg
└── README.md             # このファイル
```
