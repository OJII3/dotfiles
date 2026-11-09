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
  # T3 resolves symlinks before looking for the sibling helper.
  acpRuntime = pkgs.runCommand "agy-acp-rules-runtime" { } ''
    mkdir -p "$out/bin"
    cp ${acpRulesProxy}/bin/agy-acp-rules-proxy "$out/bin/"
    cp ${acpHarnessProxy}/bin/localharness_external "$out/bin/"
  '';
  # Antigravity は OTLP を直接出さないので、フックから Langfuse へ送る。
  # 認証情報はフックの起動時に sops の復号済みファイルから読む。
  langfuseHook = pkgs.writeShellScript "agy-langfuse-hook" ''
    exec ${pkgs.python3}/bin/python3 ${./langfuse-hook.py} "$@" \
      --endpoint https://jp.cloud.langfuse.com/api/public/otel \
      --public-key-file ${config.sops.secrets.langfuse_public_key.path} \
      --secret-key-file ${config.sops.secrets.langfuse_secret_key.path}
  '';
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

    home.file = {
      ".gemini/AGENTS.md".source = ./AGENTS.md;
      ".gemini/config/mcp_config.json".source = ./mcp_config.json;
      # T3 checks for the ACP helper beside a custom Binary path.
      ".local/lib/agy-acp-rules-proxy/agy-acp-rules-proxy".source =
        "${acpRuntime}/bin/agy-acp-rules-proxy";
      ".local/lib/agy-acp-rules-proxy/localharness_external".source =
        "${acpRuntime}/bin/localharness_external";
    }
    // lib.optionalAttrs config.dot.home.sops.enable {
      ".gemini/config/hooks.json".source = ./hooks.json;
      ".local/lib/agy-langfuse/hook".source = langfuseHook;
    };

    home.activation.agySettingsGenerate = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      PATH="${pkgs.ghq}/bin:${pkgs.git}/bin:${pkgs.jq}/bin:$PATH" \
        ${pkgs.bash}/bin/bash ${generateSettingsScript} \
        '${settingsFile}' \
        '${settingsPath}'
    '';
  };
}
