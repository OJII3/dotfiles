# nix-darwin Core modules
# System base configuration with customizable options.
#
# Options are defined in ./options.nix
# Config implementations are split into separate files for maintainability.
#
{ ... }:
{
  imports = [
    ./options.nix
    ./base.nix
    ./fonts.nix
    ./sops.nix
    ./homebrew.nix
    ./tools.nix
  ];
}
