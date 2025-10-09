{ pkgs, pkgs-stable, ... }:
{
  home.packages = with pkgs; [
    # ghostty # broken on darwin
    discord
    jetbrains-toolbox
    slack
    postman
  ];
}
