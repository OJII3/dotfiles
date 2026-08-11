{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dot.home.ai;
  basePackage = inputs.llm-agents-nix.packages.${pkgs.stdenv.hostPlatform.system}.opencode;
  # opencode は OTEL_EXPORTER_OTLP_ENDPOINT が設定されているときだけ OTLP を送る。
  # 環境全体を汚さないよう、shell の環境変数ではなくラッパーで opencode にだけ渡す。
  opencodePackage =
    if cfg.opencode.otel.endpoint == null then
      basePackage
    else
      pkgs.symlinkJoin {
        name = "opencode-otel";
        paths = [ basePackage ];
        nativeBuildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/opencode \
            --set-default OTEL_EXPORTER_OTLP_ENDPOINT ${lib.escapeShellArg cfg.opencode.otel.endpoint} \
            --run 'export OTEL_RESOURCE_ATTRIBUTES="host.name=$(${pkgs.coreutils}/bin/uname -n)"'
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
  config = lib.mkIf cfg.opencode.enable {
    home.packages = commonPackages;
    programs.opencode = {
      enable = true;
      context = ./AGENTS.md;
      package = opencodePackage;
    };
    home.file.".config/opencode/opencode.jsonc".source = ./opencode.jsonc;
    home.file.".config/opencode/tui.jsonc".source = ./tui.jsonc;
    home.file.".config/opencode/agents" = {
      source = ./agents;
      recursive = true;
    };
  };
}
