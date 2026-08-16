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
    ./anyrun
    ./browser/vivaldi
    ./fcitx5
    ./gnome
    ./hypr
    ./hyprland
    ./keyd
    ./options.nix
    ./swaync
    ./theme.nix
    ./uwsm
    ./vicinae
    ./waybar
    ./wlogout
    ./xremap

    # darwin
    ./aerospace
    ./hammerspoon
    ./jankyborders
    ./rift
  ];

  # Base desktop configuration (if needed)
  config = lib.mkIf cfg.enable {
    # Common desktop settings can go here
  };
}
