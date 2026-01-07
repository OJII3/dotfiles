# Home Manager Desktop modules
# Desktop environment configuration with customizable options.
#
# Options are defined in ./options.nix
# Config implementations are split into separate files for maintainability.
#
{ config, lib, ... }:
let
  cfg = config.my.home.desktop;
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
    ./keyd
    ./swaync
    ./theme.nix
    ./uwsm
    ./vicinae
    ./waybar
    ./wlogout
    ./xremap
  ];

  # Base desktop configuration (if needed)
  config = lib.mkIf cfg.enable {
    # Common desktop settings can go here
  };
}
