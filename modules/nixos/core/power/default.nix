{ ... }: {
  services.tlp = {
    enable = true;
    settings = {
      RESTORE_DEVICE_STATE_ON_STARTUP = 1;
    };
  };
}
