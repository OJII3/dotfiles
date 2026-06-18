# nixfmt 設定 (2026-06-18)

## 目的

`nix fmt` コマンドでリポジトリの Nix ファイルを整形できるようにし、`nix flake check` でフォーマット崩れを検出できるようにする。

## 背景

現在の `flake.nix` には `formatter` 出力も `checks` 出力も存在しない。Nix ファイルのフォーマットが統一されておらず、CI での検証もない。

## 設計

`flake.nix` の `outputs` 関数を変更し、以下を追加する:

- `formatter.<system>`: nixfmt-rfc-style パッケージを返す
- `checks.<system>.formatting`: `nixfmt --check` を走らせ、未整形があれば失敗する derivation を返す

対象システムは `nixpkgs.lib.systems.flakeExposed` で自動展開する (x86_64-linux, aarch64-linux, x86_64-darwin, aarch64-darwin)。

## 変更対象

### `flake.nix`

`outputs` 関数を以下のように変更する:

```nix
outputs = inputs: let
  inherit (inputs.nixpkgs) lib;
  systems = lib.systems.flakeExposed;
in {
  # 既存出力は維持
  nixosConfigurations = (import ./hosts inputs).nixos;
  homeConfigurations = (import ./hosts inputs).home-manager;
  darwinConfigurations = (import ./hosts inputs).nix-darwin;
  nixOnDroidConfigurations = (import ./hosts inputs).nix-on-droid;

  formatter = lib.genAttrs systems (system:
    inputs.nixpkgs.legacyPackages.${system}.nixfmt-rfc-style
  );

  checks = lib.genAttrs systems (system: {
    formatting = inputs.nixpkgs.legacyPackages.${system}.runCommand
      "nix-fmt-check-${system}"
      { src = ./.; }
      ''
        ${inputs.nixpkgs.legacyPackages.${system}.nixfmt-rfc-style}/bin/nixfmt --check $src
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

- `nixfmt-rfc-style` (RFC 166 準拠の Nix フォーマッタ、nixpkgs-unstable に収録)
- バイナリ名は `nixfmt`、`--check` フラグで検証モード
