# Nix Module Options Explorer

このスキルは、NixOSとHome Managerのモジュールオプションをプログラム的にクエリするための専門ガイドです。

## 元ソース

このスキルは以下のリポジトリから取得しました：

- **元リポジトリ**: [Omegaice/dotfiles](https://github.com/Omegaice/dotfiles)
- **元ファイル**: [.claude/skills/nix-module-options/SKILL.md](https://github.com/Omegaice/dotfiles/blob/master/.claude/skills/nix-module-options/SKILL.md)
- **作者**: Omegaice
- **ライセンス**: 元リポジトリのライセンスに従います

## 概要

flake-parts設定から事前評価された値を再利用して、モジュールオプションをクエリするための最適化されたNix式を提供します。

### 主な機能

1. **オフラインクエリ** - Webサーチやオプション検索サイトが不要
2. **上流の純粋性** - 純粋なHome Manager/NixOSモジュールをクエリ（ユーザーのカスタムモジュールは除外）
3. **パフォーマンス** - flake debugから事前評価された`pkgs`を再利用
4. **システム非依存** - 移植性のために`currentSystem`を使用
5. **完全なドキュメント** - `optionAttrSetToDocList`経由でtype、description、default、examplesを返す

## 使用方法

詳細は [SKILL.md](./SKILL.md) を参照してください。
