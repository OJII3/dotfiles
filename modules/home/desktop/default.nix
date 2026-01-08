# Home Manager Desktop modules
# Desktop environment configuration with customizable options.
#
# Options are defined in ./options.nix
# Config implementations are split into separate files for maintainability.
#
{ config, lib, ... }:
let
  cfg = config.dot.home.desktop;
in
{
  imports = [
    ./options.nix
    ./anyrun
    ./browser/vivaldi
    ./fcitx5
    ./gnome
    ./hypr
    ./hyprland
    # ./kanata
    ./keyd
    ./swaync
    ./theme.nix
    ./uwsm
    ./vicinae
    ./waybar
    ./wlogout
    ./xremap
    ./jankyborders.nix
    ./aerospace
  ];

  # Base desktop configuration (if needed)
  config = lib.mkIf cfg.enable {
    # Common desktop settings can go here
  };
}
