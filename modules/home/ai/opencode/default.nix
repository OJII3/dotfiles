{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dot.home.ai;
  opencode2 = inputs.llm-agents-nix.packages.${pkgs.stdenv.hostPlatform.system}.opencode2;

  # Langfuse の OTLP 取り込み口は HTTP/JSON を受け付けるので、opencode2 が持つ
  # JSON エクスポータをそのまま使える。認証ヘッダは sops の鍵から起動時に組み立てる。
  langfuseOtelHeaders = pkgs.writeShellScript "opencode-langfuse-otel-headers" ''
    printf 'Authorization=Basic %s,x-langfuse-ingestion-version=4' \
      "$(printf '%s:%s' "$(<${config.sops.secrets.langfuse_public_key.path})" "$(<${config.sops.secrets.langfuse_secret_key.path})" | ${pkgs.coreutils}/bin/base64 -w0)"
  '';

  opencode2Langfuse = pkgs.symlinkJoin {
    name = "opencode2-langfuse";
    paths = [ opencode2 ];
    inherit (opencode2) meta version passthru;
    preferLocalBuild = true;
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/opencode2 \
        --set-default OTEL_EXPORTER_OTLP_ENDPOINT "https://jp.cloud.langfuse.com/api/public/otel" \
        --run 'export OTEL_EXPORTER_OTLP_HEADERS="$(${langfuseOtelHeaders})"'
    '';
  };

  commonPackages =
    with pkgs;
    [
      bun
      uv
      agent-browser
    ]
    ++ lib.lists.optionals (pkgs.stdenv.hostPlatform.isLinux) [
      libnotify
    ];
in
{
  config = lib.mkIf (cfg.enable && cfg.opencode.enable) {
    home.packages = commonPackages;
    programs.opencode = {
      enable = true;
      context = ./AGENTS.md;
      package = if config.dot.home.sops.enable then opencode2Langfuse else opencode2;
    };
    home.file.".config/opencode/opencode.jsonc".source = ./opencode.jsonc;
    home.file.".config/opencode/tui.jsonc".source = ./tui.jsonc;
    home.file.".config/opencode/agents" = {
      source = ./agents;
      recursive = true;
    };
    home.file.".config/opencode/plugins/langfuse-usage.ts".source = ./plugins/langfuse-usage.ts;
  };
}
