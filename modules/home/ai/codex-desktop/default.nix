{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dot.home.ai;
  codexCli = inputs.llm-agents-nix.packages.${pkgs.stdenv.hostPlatform.system}.codex;
in
{
  config = lib.mkIf (cfg.codexDesktop.enable && pkgs.stdenv.hostPlatform.isLinux) {
    programs.codexDesktopLinux = {
      enable = true;
      # Bake CODEX_CLI_PATH into the launcher so Codex Desktop always finds
      # the CLI, even when launched from a graphical session that lacks the
      # profile on PATH.
      cliPackage = codexCli;
    };
  };
}
