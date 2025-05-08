{ ... }: {
  services.tlp = {
    enable = true;
    settings = {
      RESTORE_DEVICE_STATE_ON_STARTUP = 1;
      WIFI_PWR_ON_AC = "off";
      WIFI_PWR_ON_BAT = "off"; # power save mode, defult: on
    };
  };
}
