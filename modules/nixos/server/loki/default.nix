{ lib, config, ... }:
let
  cfg = config.dot.server;
in
{
  options.dot.server.loki = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Loki log aggregation with Promtail.";
    };
  };

  config = lib.mkIf cfg.loki.enable {
    services.loki = {
      enable = true;
      configuration = {
        auth_enabled = false;

        server = {
          http_listen_port = 3100;
        };

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

        storage_config.filesystem = {
          directory = "/var/lib/loki/chunks";
        };

        limits_config = {
          retention_period = "168h";
        };

        compactor = {
          working_directory = "/var/lib/loki/compactor";
          delete_request_store = "filesystem";
          retention_enabled = true;
        };
      };
    };

    services.promtail = {
      enable = true;
      configuration = {
        server = {
          http_listen_port = 9080;
          grpc_listen_port = 0;
        };

        positions = {
          filename = "/var/lib/promtail/positions.yaml";
        };

        clients = [
          { url = "http://localhost:3100/loki/api/v1/push"; }
        ];

        scrape_configs = [
          {
            job_name = "journal";
            journal = {
              max_age = "12h";
              labels = {
                job = "systemd-journal";
                host = "Cipher";
              };
            };
            relabel_configs = [
              {
                source_labels = [ "__journal__systemd_unit" ];
                target_label = "unit";
              }
              {
                source_labels = [ "__journal_priority_keyword" ];
                target_label = "priority";
              }
            ];
          }
          {
            job_name = "vicissitude";
            journal = {
              max_age = "12h";
              labels = {
                job = "vicissitude";
                host = "Cipher";
              };
            };
            relabel_configs = [
              {
                source_labels = [ "__journal_container_tag" ];
                regex = "vicissitude";
                action = "keep";
              }
            ];
            pipeline_stages = [
              {
                json.expressions = {
                  level = "level";
                  component = "component";
                  message = "message";
                };
              }
              {
                labels = {
                  level = null;
                  component = null;
                };
              }
            ];
          }
        ];
      };
    };

    services.grafana.provision.datasources.settings.datasources = [
      {
        name = "Loki";
        type = "loki";
        url = "http://localhost:3100";
      }
    ];

    systemd.services.promtail.serviceConfig.StateDirectory = "promtail";

    networking.firewall.allowedTCPPorts = [ 3100 ];
  };
}
