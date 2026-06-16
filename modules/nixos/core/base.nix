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
        trusted-substituters = [
          "https://ros.cachix.org"
        ];
        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "ros.cachix.org-1:dSyZxI8geDCJrwgvCOHDoAfOm5sV1wCPjBkKL+38Rvo="
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
