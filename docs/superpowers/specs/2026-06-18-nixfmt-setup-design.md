# nixfmt 設定 (2026-06-18)

## 目的

`nix fmt` コマンドでリポジトリの Nix ファイルを整形できるようにし、`nix flake check` でフォーマット崩れを検出できるようにする。

## 背景

現在の `flake.nix` には `formatter` 出力も `checks` 出力も存在しない。Nix ファイルのフォーマットが統一されておらず、CI での検証もない。

## 設計

`flake.nix` の `outputs` 関数を変更し、以下を追加する:

- `formatter.<system>`: `nixfmt-tree` パッケージを返す (公式の treefmt ラッパー)
- `checks.<system>.formatting`: ソースを writable な作業ディレクトリにコピーし `treefmt --ci --tree-root "$PWD"` を走らせる derivation を返す

対象システムは明示的にリストする: `x86_64-linux`, `aarch64-linux`, `x86_64-darwin`, `aarch64-darwin`。
(`lib.systems.flakeExposed` を使うと freebsd などで `nixfmt-tree` の評価が無限再帰するため使わない)

## 変更対象

### `flake.nix`

`outputs` 関数を以下のように変更する:

```nix
outputs = inputs: let
  inherit (inputs.nixpkgs) lib;
  systems = [
    "x86_64-linux"
    "aarch64-linux"
    "x86_64-darwin"
    "aarch64-darwin"
  ];
in {
  # 既存出力は維持
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

## 動作確認

1. `nix flake check` が成功する (整形済み状態)
2. `nix fmt` で未整形ファイルが整形される
3. 意図的に未整形のファイルを置いて `nix flake check` が失敗することを確認

## 影響範囲

- 既存ファイルは未整形の可能性が高いため、初回 `nix fmt` で大きな diff が出る
- 他の flake outputs (nixosConfigurations 等) には影響しない

## 採用するツール

- `nixfmt-tree` (nixpkgs-unstable に収録。内部で `treefmt` を使い、`nixfmt` (RFC 166) を `.nix` ファイルに自動適用する公式ラッパー)
- `treefmt --ci` で未整形検出、フォーマットも同コマンドで実行可能
- 注意: 旧名の `nixfmt-rfc-style` は deprecated で `pkgs.nixfmt` にリネーム済み。`nixfmt-tree` を使うのが推奨
- check derivation ではソースを `cp -rL` で writable な作業ディレクトリにコピーし `chmod -R u+w` で書き込み権限を付与する必要がある (Nix store は read-only)
- `treefmt --tree-root` で実際のルートディレクトリを明示しないと、treefmt が config ファイルのある `/nix/store` をルートと誤認する
- さらに、chown できないグループ (例: `UNKNOWN`) がソースに付与されていると nixfmt の atomic write が失敗する。ローカルで `nix fmt` がエラーになる場合は `chgrp -R users` で修正する
- システムリストは `lib.systems.flakeExposed` だと広すぎ (`x86_64-freebsd` 等で `nixfmt-tree` の評価が無限再帰)、`lib.systems.doubles.{darwin,linux}` だと狭すぎる (linux 系が大量に含まれる)。明示的に 4 システムを列挙する
