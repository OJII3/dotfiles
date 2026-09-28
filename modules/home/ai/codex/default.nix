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
  codexHome = "${config.home.homeDirectory}/.codex";
  codexConfigPath = "${codexHome}/config.toml";
  generateConfigScript = ./generate_config.sh;
in
{
  config = lib.mkIf (cfg.enable && cfg.codex.enable) {
    home.packages = lib.mkIf pkgs.stdenv.hostPlatform.isLinux [
      inputs.llm-agents-nix.packages.${pkgs.stdenv.hostPlatform.system}.codex
    ];

    home.file.".local/bin/codex" = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
      text = ''
        #!/bin/sh
        set -eu

        for app in /Applications/ChatGPT.app "$HOME/Applications/ChatGPT.app"; do
          codex="$app/Contents/Resources/codex-cli/bin/codex"
          if [ -x "$codex" ]; then
            exec "$codex" "$@"
          fi
        done

        printf '%s\n' 'ChatGPT.app の Codex CLI が見つかりません。ChatGPT.app をインストールまたは更新してください。' >&2
        exit 127
      '';
      executable = true;
    };

    home.file.".codex/AGENTS.md".source = ./AGENTS.md;
    home.file.".codex/pets/yachiyo".source = ./pets/yachiyo;

    home.activation.codexConfigGenerate = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      # ghq で管理されている全リポジトリを trusted として config.toml を生成
      PATH="${config.home.profileDirectory}/bin:$PATH" \
        ${pkgs.bash}/bin/bash ${generateConfigScript} \
        '${seedToml}' \
        '${codexConfigPath}'
    '';

    home.activation.herdrCodexIntegration = lib.hm.dag.entryAfter [ "codexConfigGenerate" ] ''
      # config.toml is generated above, so run Herdr's installer afterward.
      CODEX_HOME=${lib.escapeShellArg codexHome} \
        ${pkgs.herdr}/bin/herdr integration install codex
    '';
  };
}
