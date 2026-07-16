{ config, lib, ... }:
let
  cfg = config.dot.darwin.networking;
in
{
  config = lib.mkIf (cfg.enable && cfg.openssh.enable) {
    services.openssh.enable = true;
  };
}
