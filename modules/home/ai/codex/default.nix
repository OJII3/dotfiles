{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dot.home.ai;
  seedToml = ./config.toml;
  codexConfigPath = "${config.home.homeDirectory}/.codex/config.toml";
  generateConfigScript = ./generate_config.sh;
in
{
  config = lib.mkIf cfg.codex.enable {
    home.packages = with pkgs; [
      inputs.codex-cli-nix.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
    home.file.".codex/AGENTS.md".source = ./AGENTS.md;
    home.file.".codex/scripts" = {
      source = ./scripts;
      recursive = true;
    };

    home.activation.codexConfigGenerate = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      # ghq で管理されている全リポジトリを trusted として config.toml を生成
      PATH="${config.home.profileDirectory}/bin:$PATH" \
        ${pkgs.bash}/bin/bash ${generateConfigScript} \
        '${seedToml}' \
        '${codexConfigPath}'
    '';
  };
}
