# Alloy は 2 つの入口を持つ:
#   - systemd journal を読んで Loki へ
#   - OTLP (4317/4318) を受けて Tempo (traces) と Loki (logs) へ振り分け
# LAN に開けるのは OTLP のみで、Loki/Tempo/Prometheus は localhost 限定のまま。
{ config, lib, ... }:
let
  cfg = config.dot.server.observability;
in
{
  config = lib.mkIf cfg.enable {
    services.alloy.enable = true;

    environment.etc."alloy/config.alloy".text = ''
      // systemd-journal -> Loki
      loki.write "default" {
        endpoint {
          url = "http://127.0.0.1:3100/loki/api/v1/push"
        }
      }

      loki.relabel "journal" {
        forward_to = []

        rule {
          source_labels = ["__journal__systemd_unit"]
          target_label  = "unit"
        }

        rule {
          source_labels = ["__journal_priority_keyword"]
          target_label  = "priority"
        }
      }

      loki.source.journal "system" {
        max_age       = "12h"
        relabel_rules = loki.relabel.journal.rules
        forward_to    = [loki.write.default.receiver]

        labels = {
          job  = "systemd-journal",
          host = "${config.networking.hostName}",
        }
      }

      // OTLP from agent CLIs (opencode) -> Tempo (traces) / Loki (logs)
      otelcol.receiver.otlp "default" {
        grpc {
          endpoint = "0.0.0.0:4317"
        }

        http {
          endpoint = "0.0.0.0:4318"
        }

        output {
          traces = [otelcol.processor.batch.default.input]
          logs   = [otelcol.processor.batch.default.input]
        }
      }

      otelcol.processor.batch "default" {
        output {
          traces = [otelcol.exporter.otlp.tempo.input]
          logs   = [otelcol.exporter.otlphttp.loki.input]
        }
      }

      otelcol.exporter.otlp "tempo" {
        client {
          endpoint = "127.0.0.1:4319"

          tls {
            insecure = true
          }
        }
      }

      // Loki のネイティブ OTLP 取り込み口。リソース属性が structured metadata として残る。
      otelcol.exporter.otlphttp "loki" {
        client {
          endpoint = "http://127.0.0.1:3100/otlp"
        }
      }
    '';

    networking.firewall.allowedTCPPorts = [
      4317
      4318
    ];
  };
}
