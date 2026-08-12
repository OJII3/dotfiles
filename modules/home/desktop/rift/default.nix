{
  config,
  lib,
  ...
}:
let
  cfg = config.dot.home.desktop;
in
{
  config = lib.mkIf cfg.rift.enable {
    home.file.".config/rift/config.toml".source = lib.mkForce ./config.toml;
  };
}
