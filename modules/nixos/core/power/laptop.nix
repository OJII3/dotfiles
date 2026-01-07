{ lib, ... }:
{
  imports = [
    ./.
  ];

  services.tuned = {
    ppdSettings.battery = {
      balanced = "laptop-battery-powersave";
    };
  };
}
