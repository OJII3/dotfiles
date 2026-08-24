# 監視スタック。各ファイルが 1 サービスを担当し、自身の Grafana データソースも登録する。
#
# データの流れ:
#   journald                        -> Alloy -> Loki
#   opencode / Codex (OTLP HTTP :4318) -> Alloy -> Prometheus / Tempo / Loki
#   Claude Code (Prometheus :9464)  -> Prometheus (scrape)
{ ... }:
{
  imports = [
    ./options.nix
    ./alloy.nix
    ./grafana.nix
    ./loki.nix
    ./prometheus.nix
    ./tempo.nix
  ];
}
