# Onshape MCP server
#
# Onshape の API キーは sops で管理しているため、MCP クライアントが
# シェルの環境変数を継承していなくても認証できるよう、ラッパーが
# シークレットを読んでからサーバーを起動する。
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dot.home;
in
{
  config = lib.mkIf (cfg.ai.enable && cfg.sops.enable) {
    home.packages = [
      (pkgs.writeShellApplication {
        name = "onshape-mcp";
        runtimeInputs = [
          pkgs.uv
          pkgs.git
        ];
        text = ''
          ONSHAPE_ACCESS_KEY="$(<${config.sops.secrets.onshape_access_key.path})"
          ONSHAPE_SECRET_KEY="$(<${config.sops.secrets.onshape_secret_key.path})"
          export ONSHAPE_ACCESS_KEY ONSHAPE_SECRET_KEY
          exec uvx --from "git+https://github.com/hedless/onshape-mcp@v0.4.0" onshape-mcp "$@"
        '';
      })
    ];
  };
}
