{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dot.home.dev.ai;
  seedToml = ./config.toml;
  pythonWithTomlkit = pkgs.python3.withPackages (ps: [ ps.tomlkit ]);
  codexConfigPath = "${config.home.homeDirectory}/.codex/config.toml";
  codexCommand =
    if pkgs.stdenv.isDarwin then "PATH=/usr/bin:$PATH bun x @openai/codex" else "bun x @openai/codex";
in
{
  config = lib.mkIf cfg.codex.enable {
    home.packages = with pkgs; [
      bun
      pythonWithTomlkit
    ];
    programs.zsh = {
      shellAliases = {
        codex = codexCommand;
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
