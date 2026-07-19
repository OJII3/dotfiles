# Cloudflared CLI configuration
# Installs the CLI only; tunnel services are configured separately.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dot.networking;
in
{
  config = lib.mkIf (cfg.enable && cfg.cloudflared.enable) {
    environment.systemPackages = [ pkgs.cloudflared ];
  };
}
