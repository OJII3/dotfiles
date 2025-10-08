{ pkgs, inputs, ... }:
{
  imports = [
    ../../includes/darwin/core/sops.nix
    ../../includes/darwin/desktop/apps.nix
    ../../includes/darwin/fonts.nix
    ../../includes/darwin/networking.nix
    ../../includes/darwin/system.nix
  ];

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;
}
