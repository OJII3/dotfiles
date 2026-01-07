# Cyrene - WSL
# Minimal config for Windows Subsystem for Linux
#
{ pkgs, ... }:
{
  imports = [
    # WSL doesn't use the full module system
    # Only import specific needed modules
    ../../modules/nixos/core/tools.nix
    ../../modules/nixos/desktop/fonts.nix
  ];

  # ===== User configuration =====
  users.users.ojii3 = {
    isNormalUser = true;
    description = "ojii3";
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "storage"
    ];
  };

  # ===== WSL-specific configuration =====
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim
    git
  ];

  wsl.enable = true;
  wsl.defaultUser = "ojii3";

  system.stateVersion = "25.05";
}
