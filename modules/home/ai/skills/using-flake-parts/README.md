# Using Flake-Parts Expert Guide

このスキルは、flake-partsを使用してNix flake設定を構造化・モジュール化するための包括的なガイドです。

## 元ソース

このスキルは以下のリポジトリから取得しました：

- **元リポジトリ**: [Omegaice/dotfiles](https://github.com/Omegaice/dotfiles)
- **元ディレクトリ**: [.claude/skills/using-flake-parts](https://github.com/Omegaice/dotfiles/tree/master/.claude/skills/using-flake-parts)
- **作者**: Omegaice
- **ライセンス**: 元リポジトリのライセンスに従います

## ファイル構成

このスキルは以下のファイルで構成されています：

- **[SKILL.md](./SKILL.md)** - メインのスキル定義と基本的な使い方
- **[module-arguments.md](./module-arguments.md)** - モジュール引数の詳細な解説
- **[modular-organization.md](./modular-organization.md)** - モジュール構成のベストプラクティス
- **[overlays.md](./overlays.md)** - easyOverlayモジュールの使い方
- **[advanced.md](./advanced.md)** - パーティション、カスタム出力、デバッグなどの高度な機能

## 概要

flake-partsは、Nix flakeをモジュラーに構成するためのフレームワークです。このスキルでは以下のトピックをカバーしています：

### 主なトピック

1. **基本概念** - mkFlake構造、perSystem vs flakeセクション
2. **モジュール引数** - pkgs, system, inputs', self', config, final, withSystem, getSystem
3. **モジュール構成** - インポートパターン、importApply、再利用可能なモジュール
4. **オーバーレイ** - easyOverlayを使った自動オーバーレイ生成
5. **高度な機能** - パーティション、カスタム出力、デバッグモード
6. **ベストプラクティス** - 推奨パターンと避けるべきアンチパターン

## 使用方法

各トピックの詳細については、対応するMarkdownファイルを参照してください。

### 推奨読書順序

1. [SKILL.md](./SKILL.md) - 基本概念と全体像
2. [module-arguments.md](./module-arguments.md) - モジュールシステムの理解
3. [modular-organization.md](./modular-organization.md) - 構成パターンの学習
4. [overlays.md](./overlays.md) - オーバーレイの作成方法
5. [advanced.md](./advanced.md) - 高度な機能とトラブルシューティング
