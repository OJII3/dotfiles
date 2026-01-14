# Cross-platform apps (macOS & Linux)
# These packages work on both darwin and linux systems.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dot.home.apps;
in
{
  config = lib.mkIf cfg.common.enable {
    home.packages = with pkgs; [
      jetbrains-toolbox
      logisim-evolution
      postman
    ];

    programs = {
      discord.enable = true;
    };
  };
}
