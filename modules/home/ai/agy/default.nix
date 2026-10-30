{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dot.home.ai;
  settingsFile = ./settings.json;
  generateSettingsScript = ./generate_settings.sh;
  settingsPath = "${config.home.homeDirectory}/.gemini/antigravity-cli/settings.json";
  acpRulesProxy = pkgs.writeShellApplication {
    name = "agy-acp-rules-proxy";
    runtimeInputs = [ pkgs.python3 ];
    text = ''
      exec python3 ${./acp-rules-proxy.py} --proxy "$@"
    '';
  };
  acpHarnessProxy = pkgs.writeShellApplication {
    name = "localharness_external";
    runtimeInputs = [ pkgs.python3 ];
    text = ''
      exec python3 ${./acp-rules-proxy.py} --harness "$@"
    '';
  };
  commonPackages =
    with pkgs;
    [
      gomi
      bun
      uv
    ]
    ++ lib.lists.optionals (pkgs.stdenv.hostPlatform.isDarwin) [
      terminal-notifier
    ]
    ++ lib.lists.optionals (pkgs.stdenv.hostPlatform.isLinux) [
      libnotify
    ];
in
{
  config = lib.mkIf (cfg.enable && cfg.agy.enable) {
    home.packages = commonPackages ++ [
      inputs.llm-agents-nix.packages."${pkgs.stdenv.hostPlatform.system}".antigravity-cli
    ];

    home.file.".gemini/AGENTS.md".source = ./AGENTS.md;
    home.file.".gemini/config/mcp_config.json".source = ./mcp_config.json;
    # T3 checks for the ACP helper beside a custom Binary path.
    home.file.".local/lib/agy-acp-rules-proxy/agy-acp-rules-proxy".source =
      "${acpRulesProxy}/bin/agy-acp-rules-proxy";
    home.file.".local/lib/agy-acp-rules-proxy/localharness_external".source =
      "${acpHarnessProxy}/bin/localharness_external";

    home.activation.agySettingsGenerate = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      PATH="${pkgs.ghq}/bin:${pkgs.git}/bin:${pkgs.jq}/bin:$PATH" \
        ${pkgs.bash}/bin/bash ${generateSettingsScript} \
        '${settingsFile}' \
        '${settingsPath}'
    '';
  };
}
