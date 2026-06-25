# Core base configuration: user account, Nix settings.
{ config, lib, ... }:
let
  cfg = config.dot.core;
in
{
  config = lib.mkIf cfg.enable {
    # User account
    users.users.${cfg.user.name} = {
      isNormalUser = true;
      description = cfg.user.name;
      shell = cfg.user.shell;
      extraGroups = cfg.user.extraGroups;
    };

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # Nix settings
    nix = {
      settings = {
        auto-optimise-store = true;
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        substituters = [
          "https://cache.numtide.com"
          "https://ros.cachix.org"
        ];
        trusted-public-keys = [
          "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
          "ros.cachix.org-1:dSyZxI8geDCJrwgvCOHDoAfOm5sV1wCPjBkKL+38Rvo="
        ];
        trusted-users = [
          "root"
          cfg.user.name
        ];
      };
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };
    };
  };
}
