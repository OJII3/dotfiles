# OpenSSH server.
{ config, lib, ... }:
let
  cfg = config.dot.core;
in
{
  config = lib.mkIf (cfg.enable && cfg.ssh.enable) {
    services.openssh.enable = true;
  };
}
