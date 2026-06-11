{ config, lib, ... }:
{
  config = lib.mkIf config.dot.core.enable {
    security = {
      rtkit.enable = true;
      polkit = {
        enable = true;
      };
    };
  };
}
