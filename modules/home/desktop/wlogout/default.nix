{ config, lib, ... }:
let
  cfg = config.my.home.desktop;
in
{
  config = lib.mkIf cfg.wlogout.enable {
    programs.wlogout = {
      enable = true;
    };
    home.file.".config/wlogout/layout".source = ./layout;
  };
}
