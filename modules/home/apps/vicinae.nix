{ config, lib, ... }:
{
  config = lib.mkIf config.dot.home.apps.vicinae.enable {
    programs.vicinae = {
      enable = true;
      systemd.enable = true;
    };
  };
}
