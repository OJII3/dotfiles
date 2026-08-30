{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.dot.home.gaming.minecraft.enable {
    home.packages =
      [ pkgs.prismlauncher ]
      ++ lib.optionals pkgs.stdenv.hostPlatform.isDarwin [
        pkgs.brewCasks.minecraft
      ];
  };
}
