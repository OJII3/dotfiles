{ lib, config, ... }:
let
  cfg = config.dot.server;
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
    # Tailscale debug endpoint for metrics
    services.tailscale.extraDaemonFlags = [ "--debug=localhost:41234" ];

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
            job_name = "node";
            static_configs = [
              { targets = [ "localhost:${toString config.services.prometheus.exporters.node.port}" ]; }
            ];
          }
          {
            job_name = "tailscale";
            metrics_path = "/debug/metrics";
            static_configs = [
              { targets = [ "localhost:41234" ]; }
            ];
          }
        ];
        exporters.node = {
          enable = true;
          enabledCollectors = [
            "textfile"
            "cpu"
          ];
          extraFlags = [
            "--collector.textfile.directory=/var/lib/prometheus/node-exporter"
          ];
          openFirewall = true;
        };
      };
      grafana = {
        enable = true;
        openFirewall = true;
        settings = {
          server.http_addr = "0.0.0.0";
        };
      };
    };
  };
}
