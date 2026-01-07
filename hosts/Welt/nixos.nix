# Welt - Raspberry Pi 4
#
{ inputs, pkgs, ... }:
let
  hostname = "Welt";
  user = "ojii3";
in
{
  imports = [
    # Main module with options
    ../../modules/nixos
  ]
  ++ (with inputs.nixos-hardware.nixosModules; [
    raspberry-pi-4
  ]);

  # ===== Options-based configuration =====
  my = {
    core = {
      enable = true;
      audio.enable = false;      # Pi doesn't need PipeWire
      bluetooth.enable = false;  # Disable for now
      ssh.enable = true;
    };

    # Desktop options not used - custom Hyprland setup below
  };

  # ===== Host-specific configuration =====

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [ "noatime" ];
    };
  };

  networking.hostName = hostname;

  environment.systemPackages = with pkgs; [
    vim
    git
  ];

  users = {
    mutableUsers = true;
    allowNoPasswordLogin = true;
  };

  # Enable passwordless sudo.
  security.sudo.extraRules = [
    {
      users = [ user ];
      commands = [
        {
          command = "ALL";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  # Enable GPU acceleration
  hardware.raspberry-pi."4".fkms-3d.enable = true;

  services.xserver = {
    enable = true;
    displayManager = {
      gdm.enable = true;
    };
  };
  services = {
    displayManager = {
      defaultSession = "hyprland-uwsm";
      autoLogin = {
        enable = true;
        user = user;
      };
    };
  };

  virtualisation.waydroid.enable = true;

  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  system.stateVersion = "23.11";
}
