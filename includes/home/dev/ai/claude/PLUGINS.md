# Claude Code プラグイン管理

## 概要

Claude Code のプラグインを Nix で宣言的に管理します。
プラグインは `~/.claude/plugins/marketplace/` に配置されます。

## プラグインの追加方法

`plugins.nix` の `plugins` リストに追加します：

```nix
plugins = [
  {
    name = "plugin-name";  # プラグインのディレクトリ名
    src = pkgs.fetchFromGitHub {
      owner = "github-username";
      repo = "repository-name";
      rev = "v1.0.0";  # タグまたはコミットハッシュ
      sha256 = "sha256-...";  # ハッシュ値
    };
  }
];
```

## ハッシュ値の取得方法

初回は `sha256 = pkgs.lib.fakeHash;` を使用してビルドし、
エラーメッセージから正しいハッシュ値をコピーします：

```bash
home-manager switch
# エラーメッセージに正しい sha256 が表示されます
```

または `nix-prefetch-github` を使用：

```bash
nix-prefetch-github owner repo --rev tag-or-commit
```

## 例

```nix
plugins = [
  {
    name = "example-skill";
    src = pkgs.fetchFromGitHub {
      owner = "anthropics";
      repo = "example-claude-skill";
      rev = "main";
      sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    };
  }
];
```

## 注意事項

- プラグインのアップデートは `rev` と `sha256` を更新します
- `rev` には特定のタグやコミットハッシュを推奨（`main` だと再現性が低下）
- 削除する場合は `plugins` リストから該当エントリを削除して `home-manager switch`
