# NixOS modules entry point
# Defines the `dot.*` option namespace for customizing NixOS configurations.
# Each submodule declares its own options under `options.dot.<module>.*`.
#
# Usage in host configuration:
#   imports = [ ../../modules/nixos ];
#   dot.core.enable = true;
#   dot.desktop.enable = true;
#
{ ... }:
{
  imports = [
    ./core
    ./desktop
    ./server
    ./hardware
    ./networking
  ];
}
