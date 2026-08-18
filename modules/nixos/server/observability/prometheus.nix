{ config, lib, ... }:
let
  cfg = config.dot.server.observability;
  port = 9090;
  metricsDir = "/var/lib/prometheus/node-exporter";
in
{
  config = lib.mkIf cfg.enable {
    services.prometheus = {
      enable = true;
      inherit port;

      globalConfig = {
        scrape_interval = "15s";
        evaluation_interval = "30s";
      };

      # Alloy forwards Codex's OTLP metrics through Prometheus remote write.
      extraFlags = [ "--web.enable-remote-write-receiver" ];

      scrapeConfigs = [
        {
          job_name = "prometheus";
          static_configs = [ { targets = [ "localhost:${toString port}" ]; } ];
        }
        {
          job_name = "node";
          static_configs = [
            { targets = [ "localhost:${toString config.services.prometheus.exporters.node.port}" ]; }
          ];
        }
        {
          job_name = "claude-code";
          scrape_interval = "30s";
          honor_timestamps = true;
          static_configs = [ { targets = cfg.claudeCodeTargets; } ];
        }
      ];

      exporters.node = {
        enable = true;
        enabledCollectors = [
          "systemd"
          "textfile"
        ];
        extraFlags = [ "--collector.textfile.directory=${metricsDir}" ];
        openFirewall = true;
      };
    };

    services.grafana.provision.datasources.settings.datasources = [
      {
        name = "Prometheus";
        type = "prometheus";
        uid = "prometheus";
        url = "http://127.0.0.1:${toString port}";
        isDefault = true;
      }
    ];
  };
}
