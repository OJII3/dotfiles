{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dot.darwin.networking;
in
{
  config = lib.mkIf (cfg.enable && cfg.cloudflared.enable) {
    environment.systemPackages = [ pkgs.cloudflared ];
  };
}
