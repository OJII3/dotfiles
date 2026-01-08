# nix-darwin modules entry point
# This file defines the `dot.darwin.*` option namespace for customizing macOS configurations.
#
# Usage in host configuration:
#   imports = [ ../../modules/darwin ];
#   dot.darwin.core.enable = true;
#   dot.darwin.desktop.enable = true;
#
{ config, lib, ... }:
{
  imports = [
    ./core
    ./desktop
  ];

  options.dot.darwin = {
    # Placeholder for future global darwin options
    # Each submodule (core, desktop) defines their own options
    # under options.dot.darwin.<module>.*
  };
}
