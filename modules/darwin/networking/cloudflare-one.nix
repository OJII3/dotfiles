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
  config = lib.mkIf (cfg.enable && cfg.cloudflareOne.enable) {
    environment.systemPackages = with pkgs; [
      cloudflare-warp
    ];
  };
}
