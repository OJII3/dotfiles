{ pkgs, ... }:
{
  imports = [ ./common.nix ];
  programs.firefox.enable = true;
}
