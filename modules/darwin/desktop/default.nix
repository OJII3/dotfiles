# nix-darwin Desktop modules
# Desktop environment configuration with customizable options.
#
# Options are defined in ./options.nix
# Config implementations are split into separate files for maintainability.
#
{ config, lib, ... }:
let
  cfg = config.my.darwin.desktop;
in
{
  imports = [
    ./options.nix
    ./base.nix
    ./apps.nix
    ./vr.nix
  ];
}
