{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.dot.home.ai;
  system = pkgs.stdenv.hostPlatform.system;
  ocpkgs = inputs.opencode.packages.${system};
  # opencode 1.17.4 は packageManager に bun@1.3.14 を要求するが nixpkgs の bun は
  # まだ 1.3.13。ビルドスクリプトの厳密な ^バージョンチェックだけが障害なので、
  # 要求バージョンを手元の bun に合わせて緩和する。nixpkgs の bun が 1.3.14 以上に
  # なったら replace-fail が失敗して気付けるので、その時点でこの override を外す。
  opencodePkg = ocpkgs.opencode.overrideAttrs (old: {
    postPatch = (old.postPatch or "") + ''
      substituteInPlace package.json \
        --replace-fail '"bun@1.3.14"' '"bun@${pkgs.bun.version}"'
    '';
  });
  commonPackages =
    with pkgs;
    [
      bun
      uv
      (callPackage ../../../packages/gwq.nix { })
    ]
    ++ lib.lists.optionals (pkgs.stdenv.hostPlatform.isDarwin) [
      terminal-notifier
    ]
    ++ lib.lists.optionals (pkgs.stdenv.hostPlatform.isLinux) [
      libnotify
    ];
in
{
  config = lib.mkIf cfg.opencode.enable {
    home.packages = commonPackages;
    programs.opencode = {
      enable = true;
      package = opencodePkg;
      context = ./AGENTS.md;
    };
  };
}
