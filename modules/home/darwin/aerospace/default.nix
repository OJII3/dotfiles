{ config, lib, ... }:
let
  cfg = config.dot.home.darwin;
in
{
  config = lib.mkIf cfg.aerospace.enable {
    home.file.".config/aerospace/aerospace.toml".source = lib.mkForce ./aerospace.toml;
  };
}
