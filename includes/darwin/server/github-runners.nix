{ config, ... }:
{
  sops.secrets."github-runners-tuatmcc-wand" = { };
  services.github-runners = {
    tuatmcc-wand = {
      enable = true;
      name = "ojii3-laptop-macos";
      tokenFile = config.sops.secrets."github-runners-tuatmcc-wand".path;
      url = "https://github.com/tuatmcc/SchoolFestival2025_Unity";
    };
  };
}
