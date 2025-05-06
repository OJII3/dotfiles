# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }:

{
  imports = [
    ./audio.nix
    ./bluetooth.nix
    ./i18n.nix
    ./kdewallet.nix
    ./network.nix
    ./security.nix
    ./services.nix
    ./ssh.nix
    ./tools.nix
  ];

  #services.flatpak.enable = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ojii3 = {
    isNormalUser = true;
    description = "ojii3";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "storage" "vboxusers" "wireshark" "dialout" "sys" "uucp" ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # state version is in host specific config
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
}

