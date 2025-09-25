{ ... }:
{
  services.upower.enable = true;
  services.tuned = {
    enable = true;
    settings.dynamic_tuning = true;
    ppdSupport = true;
  };
}
