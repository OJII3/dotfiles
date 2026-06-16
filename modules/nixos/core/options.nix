# Core module options
# All option definitions for dot.core.*
{
  lib,
  pkgs,
  username ? "ojii3",
  ...
}:
{
  options.dot.core = {
    enable = lib.mkEnableOption "core NixOS configuration" // {
      default = true; # Common defaults shared by every host
    };

    audio = {
      enable = lib.mkEnableOption "PipeWire audio" // {
        default = true;
      };
    };

    bluetooth = {
      enable = lib.mkEnableOption "Bluetooth support" // {
        default = true;
      };
    };

    ssh = {
      enable = lib.mkEnableOption "OpenSSH server" // {
        default = true;
      };
    };

    user = {
      name = lib.mkOption {
        type = lib.types.str;
        default = username;
        description = "Primary username";
      };

      shell = lib.mkOption {
        type = lib.types.package;
        default = pkgs.zsh;
        description = "Default shell for the user";
      };

      extraGroups = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [
          "networkmanager"
          "wheel"
          "storage"
          "vboxusers"
          "wireshark"
          "dialout"
          "sys"
          "uucp"
          "input"
        ];
        description = "Extra groups for the user";
      };
    };

    virtualisation = {
      podman = {
        enable = lib.mkEnableOption "Podman container runtime";
        dockerCompat = lib.mkEnableOption "Docker CLI compatibility (podman-docker)" // {
          default = true;
        };
      };

      docker = {
        enable = lib.mkEnableOption "Docker container runtime";
        rootless = {
          enable = lib.mkEnableOption "rootless Docker mode";
        };
      };
    };

    boot = {
      loader = lib.mkOption {
        type = lib.types.enum [
          "systemd-boot"
          "grub"
          "none"
        ];
        default = "none";
        description = "Boot loader type: systemd-boot, grub, or none (manual configuration)";
      };

      efi = {
        mountPoint = lib.mkOption {
          type = lib.types.str;
          default = "/boot";
          description = "EFI system partition mount point";
        };
      };

      grub = {
        useOSProber = lib.mkEnableOption "OS prober for dual-boot detection" // {
          default = true;
        };
      };
    };
  };
}
