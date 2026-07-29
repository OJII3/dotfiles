# nix-darwin Desktop modules
# Desktop environment configuration with customizable options.
#
# Options are defined in ./options.nix
# Config implementations are split into separate files for maintainability.
#
{ ... }:
{
  imports = [
    ./options.nix
    ./base.nix
    ./apps.nix
    ./vr.nix
  ];
}
