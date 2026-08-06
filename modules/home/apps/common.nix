# Cross-platform apps (macOS & Linux)
# These packages work on both darwin and linux systems.
{
  config,
  lib,
  pkgs,
  pkgs-stable,
  ...
}:
let
  cfg = config.dot.home.apps;
in
{
  config = lib.mkIf cfg.common.enable {
    home.packages = with pkgs; [
      jetbrains-toolbox
      postman
      iperf3
      slack
    ];

    programs = {
      discord.enable = true;
      firefox.enable = !config.targets.genericLinux.enable; # use system Firefox on generic Linux
    };
  };
}
