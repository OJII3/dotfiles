{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    waydroid-helper
  ];
  virtualisation.waydroid.enable = true;
}
