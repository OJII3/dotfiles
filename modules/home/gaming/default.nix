# Home Manager Gaming modules
# Gaming configuration with customizable options.
#
# Options are defined in ./options.nix
#
{
  imports = [
    ./options.nix
    ./minecraft.nix
  ];
}
