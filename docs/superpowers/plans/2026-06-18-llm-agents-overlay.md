# llm-agents overlay 切替 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** claude code と codex cli のパッケージ供給元を `claude-code-nix` / `codex-cli-nix` から `llm-agents-nix` に統一する。

**Architecture:** `flake.nix` の `inputs` から `claude-code-nix` と `codex-cli-nix` を削除し、既存 `llm-agents-nix` 経由で `claude-code` / `codex` パッケージを取得する。`modules/home/ai/claude/` と `modules/home/ai/codex/` の `package` 参照のみ書き換え、settings.json / hooks / abbr / shim / activation を含む周辺 overlay は無変更で残す。ロック更新(`nix flake update`)は本 PR の対象外。

**Tech Stack:** Nix flakes, home-manager, `numtide/llm-agents.nix`, `programs.claude-code` (home-manager 製)

---

## ファイル構成

| File | Responsibility |
|------|---------------|
| `flake.nix` (modify) | `claude-code-nix` / `codex-cli-nix` の 2 input を削除 |
| `modules/home/ai/claude/default.nix` (modify) | package 参照を `llm-agents-nix` 経由に置換 |
| `modules/home/ai/codex/default.nix` (modify) | package 参照を `llm-agents-nix` 経由に置換 |
| `docs/superpowers/specs/2026-06-18-llm-agents-overlay-design.md` | 既存: 設計書 |

無変更: `modules/home/ai/options.nix`, `modules/home/ai/default.nix`, `modules/home/ai/superpowers.nix`, `modules/home/ai/skills.nix`, `modules/home/ai/agy/`, `modules/home/ai/opencode/`, `modules/home/ai/pi/`

---

## Task 1: 作業ブランチを作成

**Files:**
- (なし / ブランチ操作のみ)

- [ ] **Step 1: 現在の状態を確認**

```bash
git status
git branch --show-current
```

期待: `main` ブランチ・作業ツリー clean。

- [ ] **Step 2: 作業ブランチを作成して切替**

```bash
git switch -c feat/llm-agents-overlay
```

期待: `Switched to a new branch 'feat/llm-agents-overlay'`。`git branch --show-current` が `feat/llm-agents-overlay` を返す。

- [ ] **Step 3: ブランチ作成をコミットする必要なし**

ブランチ作成自体にコミットは不要。次の Task に進む。

---

## Task 2: flake.nix から不要な 2 input を削除

**Files:**
- Modify: `flake.nix:43-44`

- [ ] **Step 1: 現状の該当行を確認**

```bash
sed -n '40,48p' flake.nix
```

期待: `claude-code-nix.url = ...` と `codex-cli-nix.url = ...` の 2 行が並ぶ。

- [ ] **Step 2: 2 行を削除**

`flake.nix` の `inputs` ブロック内、`claude-code-nix.url` と `codex-cli-nix.url` の 2 行を削除する。`llm-agents-nix.url` は触らない。`antigravity-nix` / `codex-desktop-linux` も触らない。

```diff
     superpowers = {
       url = "github:obra/superpowers/v5.1.0";
       flake = false;
     };
-    claude-code-nix.url = "github:sadjow/claude-code-nix";
-    codex-cli-nix.url = "github:sadjow/codex-cli-nix";
     antigravity-nix.url = "github:jacopone/antigravity-nix";
     llm-agents-nix.url = "github:numtide/llm-agents.nix";
     codex-desktop-linux.url = "github:ilysenko/codex-desktop-linux";
```

- [ ] **Step 3: 削除結果を確認**

```bash
grep -nE 'claude-code-nix|codex-cli-nix|llm-agents-nix' flake.nix
```

期待: `claude-code-nix` / `codex-cli-nix` への言及がゼロ。`llm-agents-nix.url` の 1 行だけ残る。

- [ ] **Step 4: コミット**

```bash
git add flake.nix
git commit -m "chore(flake): drop claude-code-nix and codex-cli-nix inputs"
```

期待: `flake.nix` の diff が 2 行削除のみ。

---

## Task 3: claude モジュールの package 参照を置換

**Files:**
- Modify: `modules/home/ai/claude/default.nix:17`

- [ ] **Step 1: 現状の該当行を確認**

```bash
sed -n '15,19p' modules/home/ai/claude/default.nix
```

期待: `package = inputs.claude-code-nix.packages.${pkgs.stdenv.hostPlatform.system}.default;` が表示される。

- [ ] **Step 2: package 参照を `llm-agents-nix.claude-code` に置換**

```diff
       package = inputs.claude-code-nix.packages.${pkgs.stdenv.hostPlatform.system}.default;
```

を以下に置換する:

```nix
       package = inputs.llm-agents-nix.packages.${pkgs.stdenv.hostPlatform.system}.claude-code;
```

`inputs` 引数(`{ config, inputs, lib, pkgs, ... }`)はそのまま使える(`pi` モジュールがすでに `llm-agents-nix` を参照しているため問題なし)。

- [ ] **Step 3: 他の行は無変更であることを確認**

```bash
git diff modules/home/ai/claude/default.nix
```

期待: `package = ...` の 1 行だけが差分として表示されること。`programs.jq.enable` / `programs.claude-code.enable` / `home.file."."` 群 / abbr 定義 / shim には触れていないこと。

- [ ] **Step 4: コミット**

```bash
git add modules/home/ai/claude/default.nix
git commit -m "feat(ai/claude): source package from llm-agents-nix"
```

---

## Task 4: codex モジュールの package 参照を置換

**Files:**
- Modify: `modules/home/ai/codex/default.nix:17`

- [ ] **Step 1: 現状の該当行を確認**

```bash
sed -n '15,19p' modules/home/ai/codex/default.nix
```

期待: `inputs.codex-cli-nix.packages.${pkgs.stdenv.hostPlatform.system}.default` が `home.packages` リスト内に表示される。

- [ ] **Step 2: package 参照を `llm-agents-nix.codex` に置換**

```diff
       inputs.codex-cli-nix.packages.${pkgs.stdenv.hostPlatform.system}.default
```

を以下に置換する:

```nix
       inputs.llm-agents-nix.packages.${pkgs.stdenv.hostPlatform.system}.codex
```

リスト要素は単一 attribute path なので `;` を付けない点に注意。

- [ ] **Step 3: 他の行は無変更であることを確認**

```bash
git diff modules/home/ai/codex/default.nix
```

期待: `home.packages` 内の 1 行だけが差分として表示されること。`home.file."."` 群 / `home.activation.codexConfigGenerate` には触れていないこと。

- [ ] **Step 4: コミット**

```bash
git add modules/home/ai/codex/default.nix
git commit -m "feat(ai/codex): source package from llm-agents-nix"
```

---

## Task 5: 評価とフォーマットを検証

**Files:**
- (なし / 検証のみ)

- [ ] **Step 1: フォーマット崩れがないことを確認**

```bash
nix fmt -- --check .
```

期待: 差分ゼロで終了(exit 0)。既存 commit `926c1f0` で `nixfmt-rfc-style` formatter が導入済みのため、本変更はフォーマット規約に従う。

- [ ] **Step 2: flake 評価が通ることを確認**

```bash
nix flake check --no-build
```

期待: エラーなく終了。本変更で参照不能な input を作っていないため、評価は通るはず。`--no-build` を使うのは home / nixos 構成のフル build を回避するため(`nix flake update` をまだ行っていないので build は skip しても問題ない)。

- [ ] **Step 3: claude / codex を有効化するホストの home-manager build**

`feiciao` 等、`dot.home.ai.claude.enable = true` かつ `dot.home.ai.codex.enable = true` のホストに対して build を実行する。

```bash
nix build .#homeConfigurations."<user>@<host>".activationPackage --no-link
```

`<user>@<host>` は実際のホスト名(例: `ojii3@feiciao`)。`homeConfigurations` の正確な属性名は `git grep -nE 'homeConfigurations\\.\\.|home-manager\\.' hosts/` 等で確認する。

期待: build が成功し、`result` ディレクトリに `home-files/.claude/settings.json` などの生成物が並ぶ。

- [ ] **Step 4: 生成物が旧供給元と一致することを確認**

```bash
git diff --no-index <(git show HEAD~3:modules/home/ai/claude/settings.json) <(cat result/home-files/.claude/settings.json) || true
```

(コマンドは実際の `result` パスと `HEAD~3` の範囲に置き換えること)

期待: `settings.json` / `CLAUDE.md` / `hooks/*` / `AGENTS.md` / `config.toml` の中身が diff なし。差分が出る場合は変更が意図せず他要素へ波及しているため原因を調査する。

- [ ] **Step 5: 検証ログはコミット対象に含めない**

`result` シンボリックリンク / `result-*` ディレクトリはコミットしない。`.gitignore` を確認すること(通常は `result` が含まれているはず)。

```bash
git status
```

期待: 検証用生成物が表示されない。

---

## Task 6: プッシュして PR を作成

**Files:**
- (なし / ブランチ操作のみ)

- [ ] **Step 1: コミット履歴を確認**

```bash
git log --oneline main..HEAD
```

期待: Task 2〜4 の 3 コミットが並んでいる(例: `chore(flake): drop ...`, `feat(ai/claude): ...`, `feat(ai/codex): ...`)。Task 1 はブランチ作成のみ。

- [ ] **Step 2: プッシュ**

```bash
git push -u origin feat/llm-agents-overlay
```

期待: リモートに新ブランチが作成され、CI が走り始める(あれば)。

- [ ] **Step 3: PR を作成**

```bash
gh pr create --title "feat(ai): replace claude-code-nix / codex-cli-nix with llm-agents" --body "$(cat <<'EOF'
## Summary
- `flake.nix` の inputs から `claude-code-nix` と `codex-cli-nix` を削除
- claude / codex の package 供給元を `llm-agents-nix` に統一 (pi と同 input)
- 既存の settings.json / hooks / abbr / shim / activation は無変更

## Test plan
- [ ] `nix fmt -- --check .`
- [ ] `nix flake check --no-build`
- [ ] claude / codex を有効化するホストの `home-manager build` が通る
- [ ] 生成された `home-files/.claude/*` と `~/.codex/*` が diff なし

## Follow-up
- 別 PR で `nix flake update` を実施し `llm-agents-nix` の新リビジョンを取り込む
EOF
)"
```

期待: PR URL が表示される。

- [ ] **Step 4: CI の結果を待つ**

CI がある場合、その結果を待つ。フォーマッタ・flake check・home build が通ればマージ可能。

- [ ] **Step 5: マージ後のブランチ削除**

マージ後、リモートの作業ブランチを削除する。

```bash
gh pr merge --squash --delete-branch
```

期待: リモートから `feat/llm-agents-overlay` が消える。
