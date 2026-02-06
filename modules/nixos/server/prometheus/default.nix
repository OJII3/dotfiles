{ lib, config, pkgs, ... }:
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
    # Periodically write Tailscale metrics for node_exporter textfile collector
    systemd.services.tailscale-metrics = {
      description = "Write Tailscale metrics to textfile for Prometheus";
      after = [ "tailscaled.service" ];
      requires = [ "tailscaled.service" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.tailscale}/bin/tailscale metrics write ${metricsDir}/tailscale.prom";
      };
    };
    systemd.timers.tailscale-metrics = {
      description = "Periodically write Tailscale metrics";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "1min";
        OnUnitActiveSec = "15s";
        AccuracySec = "5s";
      };
    };
    systemd.tmpfiles.rules = [
      "d ${metricsDir} 0755 root root -"
    ];

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
        };
      };
    };
  };
}
