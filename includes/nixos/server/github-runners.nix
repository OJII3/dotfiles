{ config, pkgs, ... }:
{
  sops.secrets."github-runners-tuatmcc-wand" = { };
  services.github-runners = {
    tuatmcc-wand = {
      enable = true;
      name = "ojii3-server-nixos";
      tokenFile = config.sops.secrets."github-runners-tuatmcc-wand".path;
      url = "https://github.com/tuatmcc/SchoolFestival2025_Unity";
      extraLabels = [
        "nixos"
        "ojii3"
      ];
      extraPackages = with pkgs; [
        docker
        docker-compose
        rsync
      ];
    };
  };
}
