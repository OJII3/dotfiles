# NixOS modules entry point
# This file defines the `my.*` option namespace for customizing NixOS configurations.
#
# Usage in host configuration:
#   imports = [ ../../modules/nixos ];
#   my.core.enable = true;
#   my.desktop.enable = true;
#
{ config, lib, pkgs, ... }:
let
  cfg = config.my;
in
{
  # Import all submodules
  imports = [
    ./core
    ./desktop
    ./server
    # ./hardware  # TODO: Create hardware module
  ];

  options.my = {
    # Placeholder for future options
    # Each submodule (core, desktop, server, hardware) will define their own options
    # under options.my.<module>.*
  };

  # Global config that applies when any my.* module is used
  config = {
    # This section can be used for global defaults
  };
}
