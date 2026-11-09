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

  # opencode2 内蔵の OTel は内部処理のスパンまで送ってしまうため無効化し、
  # プラグインが組み立てるモデル呼び出し 1 回ぶんの使用量だけを送る。
  usageEndpoint = "https://opencode-usage.ojii3-cloudflare-workers-test.workers.dev/ingest";

  opencode2Usage = pkgs.symlinkJoin {
    name = "opencode2-usage";
    paths = [ opencode2 ];
    inherit (opencode2) meta version passthru;
    preferLocalBuild = true;
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/opencode2 \
        --set-default OTEL_SDK_DISABLED "true" \
        --set-default USAGE_ENDPOINT "${usageEndpoint}" \
        --run 'export USAGE_TOKEN="$(<${config.sops.secrets.usage_token.path})"'
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
      package = if config.dot.home.sops.enable then opencode2Usage else opencode2;
    };
    home.file.".config/opencode/opencode.jsonc".source = ./opencode.jsonc;
    home.file.".config/opencode/tui.jsonc".source = ./tui.jsonc;
    home.file.".config/opencode/agents" = {
      source = ./agents;
      recursive = true;
    };
    home.file.".config/opencode/plugins/usage.ts".source = ./plugins/usage.ts;
  };
}
