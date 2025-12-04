{ pkgs, ... }:
{
  imports = [ ./common.nix ];
  home.packages = with pkgs; [
    gnomeExtensions.gsconnect
  ];
}
