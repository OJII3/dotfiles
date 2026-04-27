{ lib, config, ... }:
let
  cfg = config.dot.server;
in
{
  options.dot.server.loki = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Loki log aggregation with Grafana Alloy.";
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

    services.alloy.enable = true;

    environment.etc."alloy/config.alloy".text = ''
      loki.write "default" {
        endpoint {
          url = "http://localhost:3100/loki/api/v1/push"
        }
      }

      loki.relabel "journal_system" {
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
        relabel_rules = loki.relabel.journal_system.rules
        forward_to    = [loki.write.default.receiver]

        labels = {
          job  = "systemd-journal",
          host = "Cipher",
        }
      }

      loki.relabel "journal_vicissitude" {
        forward_to = []

        rule {
          source_labels = ["__journal_container_tag"]
          regex         = "vicissitude"
          action        = "keep"
        }
      }

      loki.process "vicissitude" {
        forward_to = [loki.write.default.receiver]

        stage.json {
          expressions = {
            level     = "level",
            component = "component",
            message   = "message",
          }
        }

        stage.labels {
          values = {
            level     = "",
            component = "",
          }
        }
      }

      loki.source.journal "vicissitude" {
        max_age       = "12h"
        path          = "/var/log/journal"
        relabel_rules = loki.relabel.journal_vicissitude.rules
        forward_to    = [loki.process.vicissitude.receiver]

        labels = {
          job  = "vicissitude",
          host = "Cipher",
        }
      }
    '';

    services.grafana.provision.datasources.settings.datasources = [
      {
        name = "Loki";
        type = "loki";
        url = "http://localhost:3100";
      }
    ];

    networking.firewall.allowedTCPPorts = [ 3100 ];
  };
}
