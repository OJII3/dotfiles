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

        # TraceQL のメトリクスクエリ (count_over_time / quantile_over_time など) は
        # local-blocks プロセッサがないと動かない。opencode ダッシュボードはこれ頼み。
        metrics_generator = {
          processor.local_blocks = {
            # opencode のスパンは client/internal なので server span 限定を外す。
            filter_server_spans = false;
            # 保持期間内の過去データにもクエリできるようにする。
            flush_to_storage = true;
          };
          storage.path = "/var/lib/tempo/generator/wal";
          traces_storage.path = "/var/lib/tempo/generator/traces";
        };

        overrides.defaults.metrics_generator.processors = [ "local-blocks" ];
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
