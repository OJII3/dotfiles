{ pkgs, inputs, ... }:
{
  imports = [
    ../../includes/darwin/fonts.nix
    # ../../includes/darwin/karabiner.nix
    ../../includes/darwin/networking.nix
    ../../includes/darwin/system.nix
  ];

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.pathsToLink = [
    "/share/zsh"
  ];

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;
}
