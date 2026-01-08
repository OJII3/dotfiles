# NixOS Desktop modules
# Desktop environment configuration with customizable options.
#
# Options are defined in ./options.nix
# Config implementations are split into separate files for maintainability.
#
{ config, lib, ... }:
let
  cfg = config.dot.desktop;
in
{
  imports = [
    ./options.nix
    ./bitwarden.nix
    ./flatpak.nix
    ./fonts.nix
    ./gaming.nix
    ./greetd.nix
    ./hyprland.nix
    ./keyd.nix
    ./peripheral.nix
    ./sunshine.nix
    ./waydroid.nix
    ./gnome.nix
  ];

  # Base desktop configuration
  config = lib.mkIf cfg.enable {
    services.xserver.enable = true;
    environment.sessionVariables.NIXOS_OZONE_WL = "1";
  };
}
