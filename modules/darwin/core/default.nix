# nix-darwin Core modules
# System base configuration with customizable options.
#
# Options are defined in ./options.nix
# Config implementations are split into separate files for maintainability.
#
{ config, lib, ... }:
let
  cfg = config.dot.darwin.core;
in
{
  imports = [
    ./options.nix
    ./base.nix
    ./fonts.nix
    ./networking.nix
    ./sops.nix
  ];
}
