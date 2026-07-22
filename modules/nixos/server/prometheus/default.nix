{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.dot.server;
  metricsDir = "/var/lib/prometheus/node-exporter";
in
{
  options.dot.server.prometheus = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Prometheus monitoring.";
    };
  };
  config = lib.mkIf cfg.prometheus.enable {
    services = {
      prometheus = {
        enable = true;
        globalConfig = {
          scrape_interval = "15s";
          evaluation_interval = "30s";
        };
        scrapeConfigs = [
          {
            job_name = "prometheus";
            static_configs = [
              { targets = [ "localhost:9090" ]; }
            ];
          }
          {
            job_name = "vicissitude";
            honor_labels = true;
            static_configs = [
              { targets = [ "localhost:9091" ]; }
            ];
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
            static_configs = [
              {
                targets = [
                  "Aglaea:9464"
                  "Bronya:9464"
                  "Cyrene:9464"
                  "Cipher:9464"
                  "Himeko:9464"
                ];
              }
            ];
          }
        ];
        exporters.node = {
          enable = true;
          enabledCollectors = [
            "systemd"
            "textfile"
          ];
          extraFlags = [
            "--collector.textfile.directory=${metricsDir}"
          ];
          openFirewall = true;
        };
      };
      grafana = {
        enable = true;
        openFirewall = true;
        settings = {
          server.http_addr = "0.0.0.0";
          security.secret_key = "grafana_monitoring_key";
        };
      };
    };
  };
}
