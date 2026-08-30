{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.dot.home.gaming.minecraft.enable {
    home.packages = [ pkgs.prismlauncher ];
  };
}
