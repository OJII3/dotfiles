# nixfmt 設定 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** `flake.nix` に `formatter` と `checks` 出力を追加し、`nix fmt` と `nix flake check` で Nix ファイルのフォーマット整形・検証を行えるようにする。

**Architecture:** `nixpkgs.lib.systems.flakeExposed` で対象システムを列挙し、`lib.genAttrs` で各システム向けの `formatter` (nixfmt-rfc-style パッケージ) と `checks.formatting` (`nixfmt --check` を走らせる derivation) を生成する。

**Tech Stack:** Nix flakes, nixpkgs-unstable, nixfmt-tree (内部で treefmt + nixfmt (RFC 166) を使用)

---

## ファイル構成

| File | Responsibility |
|------|---------------|
| `flake.nix` (modify) | `formatter` と `checks` 出力を追加 |
| `docs/superpowers/specs/2026-06-18-nixfmt-setup-design.md` | 既存: 設計書 |
| `**/*.nix` (auto-formatted) | `nix fmt` 実行で自動整形されるファイル群 |

---

## Task 1: flake.nix に formatter と checks 出力を追加

**Files:**
- Modify: `flake.nix:37-45` (outputs 関数全体)

- [ ] **Step 1: flake.nix の outputs 関数を変更**

`flake.nix` の outputs ブロックを以下に置換する:

```nix
  outputs = inputs: let
    inherit (inputs.nixpkgs) lib;
    systems = lib.systems.flakeExposed;
  in {
    nixosConfigurations = (import ./hosts inputs).nixos;
    homeConfigurations = (import ./hosts inputs).home-manager;
    darwinConfigurations = (import ./hosts inputs).nix-darwin;
    nixOnDroidConfigurations = (import ./hosts inputs).nix-on-droid;

    formatter = lib.genAttrs systems (system:
      inputs.nixpkgs.legacyPackages.${system}.nixfmt-tree
    );

    checks = lib.genAttrs systems (system: {
      formatting = inputs.nixpkgs.legacyPackages.${system}.runCommand
        "nix-fmt-check-${system}"
        { src = ./.; }
        ''
          cp -rL $src src
          chmod -R u+w src
          cd src
          ${inputs.nixpkgs.legacyPackages.${system}.nixfmt-tree}/bin/treefmt --ci --tree-root "$PWD"
          touch $out
        '';
    });
  };
```

変更前 (現状):

```nix
  outputs = inputs: {
    nixosConfigurations = (import ./hosts inputs).nixos;
    homeConfigurations = (import ./hosts inputs).home-manager;
    darwinConfigurations = (import ./hosts inputs).nix-darwin;
    nixOnDroidConfigurations = (import ./hosts inputs).nix-on-droid;
  };
```

差分:
- `outputs` 関数のボディを `let ... in { ... };` 形式に変更
- `formatter` 出力を追加 (各システムの nixfmt-rfc-style パッケージ)
- `checks` 出力を追加 (各システムの formatting 検証 derivation)

- [ ] **Step 2: flake の構文が正しいか評価で確認**

Run: `nix flake show --json --no-write-lock-file 2>&1 | head -50`
Expected: JSON が出力され、`formatter` と `checks` のキーが含まれている (もしくは "error" ではなく JSON がパース可能)。初回は lock 更新が入る可能性があるので、warning は無視して良い。

注意: `nix fmt` / `nix flake check` は lock が更新されないと動かない場合があるので、必要に応じて `nix flake lock --update-input nixpkgs` を実行する (lock 全体更新は不要)。

- [ ] **Step 3: コミット**

```bash
git add flake.nix
git commit -m "feat: add nixfmt-rfc-style formatter and formatting check"
```

---

## Task 2: フォーマット検証が未整形コードを正しく検出することを確認

**Files:**
- Modify: `flake.nix` (テスト用に一時的に未整形行を追加 → 確認 → 戻す)

- [ ] **Step 1: テスト用に意図的に未整形の行を追加**

`flake.nix` の `inputs = {` の直後にスペースを入れたり、`outputs = inputs:` の前後に無関係なスペースを入れたりと、nixfmt-rfc-style が修正する種類の軽微な乱れを 1 箇所入れる。

例: `inputs = {` を `inputs   =   {` に変更 (スペースを乱す)。

- [ ] **Step 2: nix flake check が失敗することを確認**

Run: `nix flake check --no-build 2>&1 | tail -30`
Expected: `checks.x86_64-linux.formatting` などの derivation が `nixfmt: parse error` または diff 出力を伴って失敗する。失敗メッセージに差分が含まれていれば OK。

- [ ] **Step 3: 追加した乱れを元に戻す**

Step 1 で加えた変更を `git checkout flake.nix` で戻す。

- [ ] **Step 4: 検証ループ成功を確認**

Run: `git diff flake.nix`
Expected: 差分がない (空出力)。

注: Task 2 ではコミットしない。Task 1 のコミット以降に追加変更がないことを保証する。

---

## Task 3: リポジトリ全体を nix fmt で整形

**Files:**
- Modify: `**/*.nix` (自動整形)

- [ ] **Step 1: dry-run で差分確認**

Run: `nix fmt -- --check . 2>&1 | head -30`
Expected: 未整形ファイルの diff が出力される。diff が大量に出る場合は容量を確認。

- [ ] **Step 2: 実際に整形を実行**

Run: `nix fmt`
Expected: 終了コード 0、差分がなくなる。

- [ ] **Step 3: 差分の妥当性を確認**

Run: `git diff --stat | tail -30`
Expected: 整形されたファイル一覧と追加/削除行数が出る。各ファイルの変更がフォーマット起因 (空白・改行) であることを目視確認。

- [ ] **Step 4: nix flake check が通ることを確認**

Run: `nix flake check 2>&1 | tail -20`
Expected: 成功 (または lock 更新警告のみ)。`formatting` check が pass する。

- [ ] **Step 5: コミット**

```bash
git add -u
git commit -m "style: apply nixfmt-rfc-style formatting"
```

---

## Task 4: ブランチを push して PR を作成

**Files:**
- Modify: なし (git 操作のみ)

- [ ] **Step 1: push**

```bash
git push -u origin feat/nix-fmt
```

Expected: リモートにブランチが push される。

- [ ] **Step 2: PR 作成**

`gh pr create` が使える場合は:

```bash
gh pr create --title "feat: add nixfmt-rfc-style formatter and check" --body "$(cat <<'EOF'
## 概要
- `flake.nix` に `formatter.<system>` 出力 (nixfmt-rfc-style) を追加
- `flake.nix` に `checks.<system>.formatting` 出力 (`nixfmt --check` によるフォーマット検証) を追加
- 対象システムは `lib.systems.flakeExposed` で自動展開
- 既存 Nix ファイルを nixfmt-rfc-style で整形

## 動作
- `nix fmt` でリポジトリ全体を整形
- `nix flake check` でフォーマット崩れを検出 (CI 向け)

## spec / plan
- spec: `docs/superpowers/specs/2026-06-18-nixfmt-setup-design.md`
- plan: `docs/superpowers/plans/2026-06-18-nixfmt-setup.md`
EOF
)"
```

Expected: PR の URL が表示される。

`gh` が使えない場合は push だけ行い、ユーザーに PR 作成を依頼する。
