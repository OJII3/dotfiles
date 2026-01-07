# nix-darwin modules entry point
# This file defines the `my.darwin.*` option namespace for customizing macOS configurations.
#
# Usage in host configuration:
#   imports = [ ../../modules/darwin ];
#   my.darwin.core.enable = true;
#   my.darwin.desktop.enable = true;
#
{ config, lib, ... }:
{
  imports = [
    ./core
    ./desktop
  ];

  options.my.darwin = {
    # Placeholder for future global darwin options
    # Each submodule (core, desktop) defines their own options
    # under options.my.darwin.<module>.*
  };
}
