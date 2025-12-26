# Claude Code Agent Skills 管理

## 概要

Claude Code の Agent Skills を Nix で宣言的に管理します。
- 外部スキル: `~/.claude/skills/` に配置
- ローカルスキル: `~/.claude/skills/local/` に配置

## スキルの種類

### 外部スキル（GitHub から取得）

公開されているスキルを `skills.nix` で管理します。
バージョン固定で再現可能な環境を構築できます。

### ローカルスキル（自作スキル）

`skills/local/` ディレクトリで独自のスキルを開発します。
dotfiles で管理することで、複数の環境で同期できます。

## 外部スキルの追加方法

`skills.nix` の `skills` リストに追加します：

```nix
skills = [
  {
    name = "skill-name";  # スキルのディレクトリ名
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

## ローカルスキルの開発

`skills/local/` 配下に新しいディレクトリを作成：

```
skills/local/
└── my-custom-skill/
    ├── skill.ts          # メインのスキル実装
    ├── package.json      # 依存関係（必要な場合）
    └── README.md         # スキルの説明
```

### スキルの基本構造

```typescript
// skill.ts
export default {
  name: "my-custom-skill",
  description: "スキルの説明",

  async execute(context) {
    // スキルのロジック
    return {
      success: true,
      message: "実行完了"
    };
  }
};
```

## 例

### 外部スキルの例

```nix
skills = [
  {
    name = "pdf-processor";
    src = pkgs.fetchFromGitHub {
      owner = "anthropics";
      repo = "claude-skill-pdf";
      rev = "v1.0.0";
      sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    };
  }
];
```

### ローカルスキルの例

`skills/local/nix-helper/skill.ts`:

```typescript
export default {
  name: "nix-helper",
  description: "Nix 環境のヘルパー",

  async execute({ task }) {
    // Nix 関連のタスクを実行
    return { success: true };
  }
};
```

## 注意事項

- **外部スキル**:
  - アップデートは `rev` と `sha256` を更新
  - `rev` には特定のタグやコミットハッシュを推奨（`main` だと再現性が低下）
  - 削除する場合は `skills` リストから該当エントリを削除して `home-manager switch`

- **ローカルスキル**:
  - `skills/local/` 配下のディレクトリは自動的に `~/.claude/skills/local/` にリンク
  - TypeScript で記述する場合は、必要に応じて `package.json` で依存関係を管理
  - スキル名はディレクトリ名と一致させることを推奨

## トラブルシューティング

### スキルが読み込まれない

1. `home-manager switch` を実行してシンボリックリンクを更新
2. `ls -la ~/.claude/skills/` でスキルが配置されているか確認
3. スキルの `skill.ts` が正しい構造になっているか確認

### 外部スキルのビルドエラー

1. `sha256` ハッシュが正しいか確認
2. `rev` が存在するタグ/コミットか確認
3. リポジトリがアクセス可能か確認

## 参考リンク

- [Claude Agent SDK ドキュメント](https://github.com/anthropics/anthropic-sdk-typescript)
- [Claude Code Agent Skills ガイド](https://docs.anthropic.com/claude/docs)
