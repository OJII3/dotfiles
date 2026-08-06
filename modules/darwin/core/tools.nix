{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.dot.darwin.core;
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      vim
      git
      gnumake
      python312
      iproute2mac
    ];
  };
}
