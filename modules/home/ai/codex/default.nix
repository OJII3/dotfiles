{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dot.home.ai;
  seedToml = ./config.toml;
  pythonWithTomlkit = pkgs.python3.withPackages (ps: [ ps.tomlkit ]);
  codexConfigPath = "${config.home.homeDirectory}/.codex/config.toml";
  commonPackages =
    with pkgs;
    [
      gomi
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
  config = lib.mkIf cfg.codex.enable {
    home.packages = commonPackages ++ [
      pythonWithTomlkit
    ];
    programs.zsh = {
      shellAliases = {
        codex = "bun x @openai/codex";
      };
    };

    home.file.".codex/AGENTS.md".source = ./AGENTS.md;
    home.file.".codex/scripts" = {
      source = ./scripts;
      recursive = true;
    };

    home.activation.codexSeedMerge = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      # ~/.codex は writable のまま維持し、config.toml を symlink にしない
      # seed 優先の深い fill-missing でマージする
      ${pythonWithTomlkit}/bin/python ${./merge_codex_config.py} \
        --seed '${seedToml}' \
        --config '${codexConfigPath}'
    '';
  };
}
