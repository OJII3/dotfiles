# Home Manager Terminal modules
# Terminal emulator configuration with customizable options.
#
# Options are defined in ./options.nix
#
{ config, lib, pkgs, ... }:
let
  cfg = config.dot.home.terminal;
in
{
  imports = [
    ./options.nix
    ./ghostty
    ./kitty
    ./wezterm
  ];

  # Base terminal configuration
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      hackgen-nf-font
    ];
  };
}
