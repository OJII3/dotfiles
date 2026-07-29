# nix-darwin modules entry point
# This file defines the `dot.darwin.*` option namespace for customizing macOS configurations.
#
# Usage in host configuration:
#   imports = [ ../../modules/darwin ];
#   dot.darwin.core.enable = true;
#   dot.darwin.desktop.enable = true;
#
{ ... }:
{
  imports = [
    ./base.nix
    ./core
    ./desktop
    ./networking
  ];
}
