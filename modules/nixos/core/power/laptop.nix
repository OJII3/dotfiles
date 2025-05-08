{ ... }: {
  imports = [
    ./.
  ];

  services.tlp = {
    enable = true;
    settings = {
      START_CHARGE_THRESH_BAT0 = 75;
      STOP_CHARGE_THRESH_BAT0 = 90;

      MEM_SLEEP_ON_AC = "s2idle";
      MEM_SLEEP_ON_BAT = "s2idle";

      CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      PLATFORM_PROFILE_ON_AC = "performance";
      PLATFORM_PROFILE_ON_BAT = "low-power";
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;

      USB_AUTOSUSPEND = 1;
      USB_EXCLUDE_WWAN = 1;
    };
  };
}
