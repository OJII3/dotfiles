{ pkgs, ... }:
{
  imports = [
    ../../includes/nixos/core/tools.nix
    ../../includes/nixos/desktop/fonts.nix
  ];
  users.users.ojii3 = {
    isNormalUser = true;
    description = "ojii3";
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "storage"
    ];
  };
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    vim
    git
  ];
  wsl.enable = true;
  wsl.defaultUser = "ojii3";
  system.stateVersion = "25.05";
}
