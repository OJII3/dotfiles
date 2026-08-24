{ config, lib, ... }:
let
  cfg = config.dot.server.observability;
in
{
  config = lib.mkIf cfg.enable {
    services.grafana = {
      enable = true;
      openFirewall = true;
      settings = {
        server = {
          http_addr = "0.0.0.0";
          http_port = 3000;
        };
        # LAN 内限定運用のため固定値。外部公開する場合は sops 管理に移すこと。
        security.secret_key = "grafana_monitoring_key";
      };

      provision.dashboards.settings.providers = [
        {
          name = "Codex";
          options.path = ./dashboards/codex;
          disableDeletion = true;
          allowUiUpdates = false;
        }
      ];
    };
  };
}
