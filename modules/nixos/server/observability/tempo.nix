{ config, lib, ... }:
let
  cfg = config.dot.server.observability;
  httpPort = 3200;
  # 標準の 4317/4318 は Alloy の OTLP receiver が使うので、Tempo 側はずらす。
  otlpPort = 4319;
in
{
  config = lib.mkIf cfg.enable {
    services.tempo = {
      enable = true;
      settings = {
        server = {
          http_listen_port = httpPort;
          # Loki と Tempo は既定でどちらも gRPC 9095 を掴むのでずらす。
          grpc_listen_port = 9096;
        };

        distributor.receivers.otlp.protocols.grpc.endpoint = "127.0.0.1:${toString otlpPort}";

        ingester.max_block_duration = "5m";

        compactor.compaction.block_retention = cfg.retention;

        storage.trace = {
          backend = "local";
          wal.path = "/var/lib/tempo/wal";
          local.path = "/var/lib/tempo/blocks";
        };
      };
    };

    services.grafana.provision.datasources.settings.datasources = [
      {
        name = "Tempo";
        type = "tempo";
        uid = "tempo";
        url = "http://127.0.0.1:${toString httpPort}";
        jsonData.tracesToLogsV2 = {
          datasourceUid = "loki";
          spanStartTimeShift = "-5m";
          spanEndTimeShift = "5m";
          filterByTraceID = true;
        };
      }
    ];
  };
}
