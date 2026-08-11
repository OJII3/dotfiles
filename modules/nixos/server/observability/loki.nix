{ config, lib, ... }:
let
  cfg = config.dot.server.observability;
  port = 3100;
in
{
  config = lib.mkIf cfg.enable {
    services.loki = {
      enable = true;
      configuration = {
        auth_enabled = false;

        server.http_listen_port = port;

        common = {
          path_prefix = "/var/lib/loki";
          ring = {
            instance_addr = "127.0.0.1";
            kvstore.store = "inmemory";
          };
          replication_factor = 1;
        };

        schema_config.configs = [
          {
            from = "2024-01-01";
            store = "tsdb";
            object_store = "filesystem";
            schema = "v13";
            index = {
              prefix = "index_";
              period = "24h";
            };
          }
        ];

        storage_config.filesystem.directory = "/var/lib/loki/chunks";

        limits_config = {
          retention_period = cfg.retention;
          # OTLP 取り込みはリソース属性を structured metadata として保存するため必須。
          allow_structured_metadata = true;
        };

        compactor = {
          working_directory = "/var/lib/loki/compactor";
          delete_request_store = "filesystem";
          retention_enabled = true;
        };
      };
    };

    services.grafana.provision.datasources.settings.datasources = [
      {
        name = "Loki";
        type = "loki";
        uid = "loki";
        url = "http://127.0.0.1:${toString port}";
        # OTLP 経由のログには trace_id が structured metadata として付くので、
        # ログから該当トレースへ飛べるようにする。
        jsonData.derivedFields = [
          {
            name = "TraceID";
            matcherType = "label";
            matcherRegex = "trace_id";
            url = "\${__value.raw}";
            datasourceUid = "tempo";
          }
        ];
      }
    ];
  };
}
