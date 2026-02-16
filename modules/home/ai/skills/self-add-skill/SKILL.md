---
name: self-add-skill
description: home-manager 管理環境で新しいスキルを追加するためのガイド。ユーザーが新しい▽ゆースキルを作成したいとき、~/.claude/skills や ~/.codex/skills に直接作成する代わりに、dotfiles リポジトリ内の modules/home/ai/skills/ に作成し、home-manager switch で適用する必要がある環境、つまりユーザー単位向け。dotfiles でない場合、基本的にプロジェクト単位で追加するため、このスキルは使用しない。
---

このスキルは、home-manager 管理環境で新しいスキルを追加するための手順をガイドします。

## 背景

この環境では、スキルは Nix home-manager によって管理されています。`~/.claude/skills/` や `~/.codex/skills/` に直接ファイルを作成しても、次回の `home-manager switch` で上書きされてしまいます。

そのため、新しいスキルを追加するには以下の場所に作成する必要があります：
- `modules/home/ai/skills/<skill-name>/SKILL.md`

## 手順

ユーザーが新しいスキルを追加したいときは、以下の手順で実行してください：

### 1. スキル情報の収集

ユーザーに以下の情報を確認してください：
- **スキル名** (ディレクトリ名として使用、英数字とハイフンのみ)
- **description** (スキルの説明、1-2文程度)
- **スキルの内容** (SKILL.md の本文)

### 2. スキルディレクトリの作成

dotfiles リポジトリ内にスキルディレクトリを作成します：

```bash
mkdir -p ~/src/github.com/ojii3/dotfiles/modules/home/ai/skills/<skill-name>
```

### 3. SKILL.md の作成

以下のフォーマットで `SKILL.md` を作成します：

```markdown
---
name: <skill-name>
description: <スキルの説明>
---

<スキルの本文>
```

### 4. Git に追加

```bash
cd ~/src/github.com/ojii3/dotfiles
git add modules/home/ai/skills/<skill-name>
```

### 5. home-manager switch の実行

ホスト名を取得して home-manager switch を実行します：

```bash
cd ~/src/github.com/ojii3/dotfiles
home-manager switch --flake .#ojii3@$(hostname)
```

### 6. 確認

スキルが正しく追加されたことを確認します：

```bash
ls -la ~/.claude/skills/<skill-name>
ls -la ~/.codex/skills/<skill-name>
```

## 注意事項

- スキル名は英数字とハイフンのみ使用可能です
- SKILL.md の frontmatter には必ず `name` と `description` を含めてください
- 変更を永続化するには、適切なタイミングで git commit してください
- 他の人と共有する場合は、commit 後に push してください

## 例

ユーザーが「コードレビュースキル」を追加したい場合：

```bash
# 1. ディレクトリ作成
mkdir -p ~/src/github.com/ojii3/dotfiles/modules/home/ai/skills/code-review

# 2. SKILL.md を作成 (Write ツールを使用)

# 3. Git に追加
cd ~/src/github.com/ojii3/dotfiles
git add modules/home/ai/skills/code-review

# 4. home-manager switch
home-manager switch --flake .#ojii3@$(hostname)
```
