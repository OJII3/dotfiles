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
in
{
  config = lib.mkIf cfg.codex.enable {
    home.packages = [
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
