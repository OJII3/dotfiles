{ pkgs, ... }:
{
  home.packages = with pkgs; [
    jetbrains-toolbox
    slack
    postman
  ];
}
