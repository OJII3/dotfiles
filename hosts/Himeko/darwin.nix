{ pkgs, inputs, ... }:
{
  imports = [
    ../../modules/darwin/core/fonts.nix
    ../../modules/darwin/core/networking.nix
    ../../modules/darwin/core/sops.nix
    ../../modules/darwin/desktop/apps.nix
    ../../modules/darwin/desktop/vr.nix
  ];

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;
}
