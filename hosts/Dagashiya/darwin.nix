{ pkgs, inputs, ... }: {
  imports = [
    ../../modules/darwin/fonts.nix
    ../../modules/darwin/homebrew.nix
    ../../modules/darwin/networking.nix
    ../../modules/darwin/system.nix
    ../../modules/darwin/window-manager.nix
  ];

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    vim
    git
    gnumake
    python311
  ];

  environment.pathsToLink = [
    "/share/zsh"
  ];

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;
}

