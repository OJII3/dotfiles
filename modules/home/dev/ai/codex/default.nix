{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dot.home.dev.ai;
  tomlFormat = pkgs.formats.toml { };
  seedToml = tomlFormat.generate "codex-seed.toml" {
    approval_policy = "on-request";
    sandbox_mode = "workspace-write";
    features = {
      web_search_request = true;
    };
  };
  pythonWithTomlkit = pkgs.python3.withPackages (ps: [ ps.tomlkit ]);
  seedPath = "${config.xdg.configHome}/codex/seed.toml";
  codexConfigPath = "${config.home.homeDirectory}/.codex/config.toml";
in
{
  config = lib.mkIf cfg.codex.enable {
    home.packages = with pkgs; [
      bun
      pythonWithTomlkit
    ];
    programs.zsh.shellAliases = {
      codex = "bun x @openai/codex";
    };

    home.file.".codex/AGENTS.md".source = ./AGENTS.md;
    xdg.configFile."codex/seed.toml".source = seedToml;

    home.activation.codexSeedMerge = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      # ~/.codex は writable のまま維持し、config.toml を symlink にしない
      # seed 優先の深い fill-missing でマージする
      ${pythonWithTomlkit}/bin/python ${./merge_codex_config.py} \
        --seed '${seedPath}' \
        --config '${codexConfigPath}'
    '';
  };
}
