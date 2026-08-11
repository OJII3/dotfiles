# Alloy は systemd journal を読んで Loki へ流す。
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
    '';
  };
}
