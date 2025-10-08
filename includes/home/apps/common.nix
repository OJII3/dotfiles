{ pkgs, pkgs-stable, ... }:
{
  home.packages = with pkgs; [
    # ghostty # broken on darwin
    pkgs-stable.blender
    discord
    jetbrains-toolbox
    slack
    postman
    # immersed
  ];
}
