{ config, lib, ... }:
let
  cfg = config.dot.desktop.power;
in
{
  config = lib.mkIf cfg.serverLike {
    services.displayManager.gdm.autoSuspend = false;

    services.logind.settings.Login = {
      HandleLidSwitch = "ignore";
      HandleLidSwitchExternalPower = "ignore";
      HandleLidSwitchDocked = "ignore";
    };
  };
}
