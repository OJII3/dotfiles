{ config, lib, ... }:
{
  config = lib.mkIf config.dot.core.enable {
    services.envfs.enable = true;
    services.gvfs.enable = true;
    services.udisks2.enable = true;
    services.devmon.enable = true;
    services.printing.enable = true; # CUPS
  };
}
