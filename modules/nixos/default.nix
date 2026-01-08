# NixOS modules entry point
# This file defines the `dot.*` option namespace for customizing NixOS configurations.
#
# Usage in host configuration:
#   imports = [ ../../modules/nixos ];
#   dot.core.enable = true;
#   dot.desktop.enable = true;
#
{ config, lib, pkgs, ... }:
let
  cfg = config.dot;
in
{
  # Import all submodules
  imports = [
    ./core
    ./desktop
    ./server
    ./hardware
    ./networking
  ];

  options.dot = {
    # Placeholder for future options
    # Each submodule (core, desktop, server, hardware) will define their own options
    # under options.dot.<module>.*
  };

  # Global config that applies when any dot.* module is used
  config = {
    # This section can be used for global defaults
  };
}
