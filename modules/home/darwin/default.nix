# Home Manager Darwin modules
# macOS-specific configuration with customizable options.
#
# Options are defined in ./options.nix
#
{ ... }:
{
  imports = [
    ./options.nix
    ./aerospace
    ./jankyborders
    ./skhd
  ];
}
