{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dot.home.ai;
in
{
  config = lib.mkIf (cfg.enable) {
    home.packages = [ pkgs.herdr ];

    home.file.".config/herdr/config.toml".source = ./config.toml;
  };
}
