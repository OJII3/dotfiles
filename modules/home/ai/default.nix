# Home Manager AI modules
# AI assistant configuration with customizable options.
#
# Options are defined in ./options.nix
#
{ ... }:
{
  imports = [
    ./options.nix
    ./claude
    ./codex
    ./opencode
    ./gemini
  ];
}
