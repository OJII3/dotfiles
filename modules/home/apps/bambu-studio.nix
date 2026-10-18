{ config, lib, pkgs, ... }:
{
  config = lib.mkIf config.dot.home.apps.bambuStudio.enable {
    home.packages = [
      (
        if pkgs.stdenv.hostPlatform.isDarwin then
          pkgs.brewCasks.bambu-studio
        else
          pkgs.bambu-studio
      )
    ];
  };
}
