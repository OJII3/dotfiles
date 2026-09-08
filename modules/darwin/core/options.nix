# Core module options
# All option definitions for dot.darwin.core.*
{ lib, ... }:
{
  options.dot.darwin.core = {
    enable = lib.mkEnableOption "core darwin configuration";

    bitwarden = {
      enable = lib.mkEnableOption "bitwarden password manager";
    };

    fonts = {
      enable = lib.mkEnableOption "custom fonts via Homebrew";
    };

    sops = {
      enable = lib.mkEnableOption "sops-nix secrets management";
    };
  };
}
