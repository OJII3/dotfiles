{ inputs, pkgs, ... }:
let
  hostname = "Welt";
  user = "ojii3";
in
{
  imports = [
    ../../modules/core
  ]
  ++ (with inputs.nixos-hardware.nixosModules; [
    raspberry-pi-4
  ]);

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
