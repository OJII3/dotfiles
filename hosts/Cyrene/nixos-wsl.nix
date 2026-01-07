# Cyrene - WSL
# Minimal config for Windows Subsystem for Linux
#
{ pkgs, ... }:
{
  imports = [
    ../../modules/nixos
  ];

  # ===== Options-based configuration =====
  my = {
    core = {
      enable = true;
      audio.enable = false;      # WSL doesn't need audio
      bluetooth.enable = false;  # WSL doesn't need Bluetooth
      ssh.enable = false;        # Use Windows SSH
    };

    desktop = {
      enable = true;
      fonts.enable = true;
    };
  };

  # ===== WSL-specific configuration =====
  environment.systemPackages = with pkgs; [
    vim
    git
  ];

  wsl.enable = true;
  wsl.defaultUser = "ojii3";

  system.stateVersion = "25.05";
}
