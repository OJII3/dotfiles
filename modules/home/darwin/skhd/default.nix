{ config, lib, ... }:
let
  cfg = config.my.home.darwin;
in
{
  config = lib.mkIf cfg.skhd.enable {
    services.skhd = {
      enable = true;
      config = builtins.readFile ./skhdrc;
    };
  };
}
