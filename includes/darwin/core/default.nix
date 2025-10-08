{ lib, ... }:
{
  nix.enable = lib.mkForce true;
  environment.pathsToLink = [
    "/share/zsh"
  ];

}
