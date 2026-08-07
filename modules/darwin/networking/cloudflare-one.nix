{ config, lib, ... }:
let
  cfg = config.dot.darwin.networking;
in
{
  config = lib.mkIf (cfg.enable && cfg.cloudflareOne.enable) {
    homebrew.casks = [ "cloudflare-warp" ];
  };
}
