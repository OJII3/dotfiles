# Grafana / Prometheus / Loki / Tempo / Alloy をひとまとめに扱う。
# 個別に使う想定がないため、トグルはスタック単位の 1 つだけにしている。
{ lib, ... }:
{
  options.dot.server.observability = {
    enable = lib.mkEnableOption "observability stack (Grafana, Prometheus, Loki, Tempo, Alloy)";

    retention = lib.mkOption {
      type = lib.types.str;
      default = "168h";
      description = "Retention period applied to both Loki logs and Tempo traces.";
    };

    claudeCodeTargets = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "Aglaea:9464"
        "Bronya:9464"
        "Cyrene:9464"
        "Cipher:9464"
        "Himeko:9464"
      ];
      description = ''
        Prometheus scrape targets exposing Claude Code metrics.
        Claude Code serves these itself when `OTEL_METRICS_EXPORTER=prometheus`
        is set (see modules/home/ai/claude/settings.json), default port 9464.
      '';
    };
  };
}
