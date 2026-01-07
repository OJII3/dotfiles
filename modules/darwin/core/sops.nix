# SOPS secrets configuration
# Applied when my.darwin.core.sops.enable is true
{ config, lib, inputs, username, ... }:
let
  cfg = config.my.darwin.core;
in
{
  imports = [
    inputs.sops-nix.darwinModules.sops
  ];

  config = lib.mkIf (cfg.enable && cfg.sops.enable) {
    sops = {
      defaultSopsFile = ../../../assets/secrets/secrets.json;
      defaultSopsFormat = "json";
      gnupg.home = "/Users/${username}/.gnupg";
      gnupg.sshKeyPaths = [ ];
    };
  };
}
