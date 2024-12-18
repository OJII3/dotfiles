# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }:

{
  imports = [
    ./audio.nix
    ./bluetooth.nix
    ./gpg.nix
    ./i18n.nix
    ./keymap.nix
    ./network.nix
    ./security.nix
    ./services.nix
    ./ssh.nix
    ./tools.nix
    ./virtualisation.nix
  ];

  #services.flatpak.enable = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ojii3 = {
    isNormalUser = true;
    description = "ojii3";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "storage" "vboxusers" "wireshark" "dialout" "sys" ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  # system.stateVersion = "24.05"; # Did you read the comment?

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

