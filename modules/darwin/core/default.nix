# nix-darwin Core modules
# System base configuration with customizable options.
#
# Options are defined in ./options.nix
# Config implementations are split into separate files for maintainability.
#
{ ... }:
{
  imports = [
    ./base.nix
    ./bitwarden.nix
    ./fonts.nix
    ./homebrew.nix
    ./options.nix
    ./sops.nix
    ./tools.nix
  ];
}
