# Core module options
# All option definitions for my.darwin.core.*
{ lib, ... }:
{
  options.my.darwin.core = {
    enable = lib.mkEnableOption "core darwin configuration";

    fonts = {
      enable = lib.mkEnableOption "custom fonts via Homebrew";
    };

    networking = {
      enable = lib.mkEnableOption "networking configuration";
    };

    sops = {
      enable = lib.mkEnableOption "sops-nix secrets management";
    };
  };
}
