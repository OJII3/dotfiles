{ config, lib, ... }:
let
  cfg = config.dot.home.desktop;
in
{
  config = lib.mkIf cfg.aerospace.enable {
    home.file.".config/aerospace/aerospace.toml".source = lib.mkForce ./aerospace.toml;
  };
}
