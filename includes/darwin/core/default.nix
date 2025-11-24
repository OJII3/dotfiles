{ ... }:
{
  nix.enable = false;
  environment.pathsToLink = [
    "/share/zsh"
  ];
}
