{ ... }: {
  imports = [ ./. ];

  networking.networkmanager = {
    enable = true;
    wifi = {
      macAddress = "random";
      scanRandMacAddress = false;
      powersave = false;
    };
    dns = "systemd-resolved";
  };
}
