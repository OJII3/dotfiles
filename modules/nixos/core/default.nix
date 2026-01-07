# NixOS Core modules
# Basic system configuration that most hosts will need.
#
# Options:
#   my.core.enable        - Enable core configuration (default: true for backward compat)
#   my.core.audio.enable  - Enable PipeWire audio
#   my.core.bluetooth.enable - Enable Bluetooth
#   my.core.ssh.enable    - Enable OpenSSH
#   my.core.user.name     - Username (default: "ojii3")
#
{ config, lib, pkgs, username ? "ojii3", ... }:
let
  cfg = config.my.core;
in
{
  imports = [
    # These are always imported but controlled by mkIf
    ./i18n.nix
    ./kdewallet.nix
    ./security.nix
    ./services.nix
    ./tools.nix
    ./uinput.nix
  ];

  options.my.core = {
    enable = lib.mkEnableOption "core NixOS configuration" // {
      default = true;  # Backward compatible: enabled by default
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
        type = lib.types.enum [ "systemd-boot" "grub" "none" ];
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

  config = lib.mkIf cfg.enable (lib.mkMerge [
    # Base configuration
    {
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
        };
        gc = {
          automatic = true;
          dates = "weekly";
          options = "--delete-older-than 7d";
        };
      };
    }

    # Audio (PipeWire)
    (lib.mkIf cfg.audio.enable {
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
      };

      programs.noisetorch.enable = true;

      environment.systemPackages = [ pkgs.helvum ];
    })

    # Bluetooth
    (lib.mkIf cfg.bluetooth.enable {
      hardware.bluetooth = {
        enable = true;
        powerOnBoot = true;
        settings = {
          General = {
            Experimental = true;
          };
        };
      };
    })

    # SSH
    (lib.mkIf cfg.ssh.enable {
      services.openssh.enable = true;
    })

    # Podman
    (lib.mkIf cfg.virtualisation.podman.enable {
      virtualisation.podman = {
        enable = true;
        dockerCompat = cfg.virtualisation.podman.dockerCompat;
        defaultNetwork.settings.dns_enabled = true;
      };
    })

    # Docker
    (lib.mkIf cfg.virtualisation.docker.enable {
      virtualisation.docker = {
        enable = true;
        rootless = {
          enable = cfg.virtualisation.docker.rootless.enable;
          setSocketVariable = cfg.virtualisation.docker.rootless.enable;
        };
      };
      # Disable podman dockerCompat when using Docker
      virtualisation.podman.dockerCompat = lib.mkForce false;

      # Add user to docker group for non-rootless mode
      users.users.${cfg.user.name}.extraGroups =
        lib.mkIf (!cfg.virtualisation.docker.rootless.enable) [ "docker" ];
    })

    # Boot - systemd-boot
    (lib.mkIf (cfg.boot.loader == "systemd-boot") {
      boot.loader = {
        efi = {
          canTouchEfiVariables = true;
          efiSysMountPoint = cfg.boot.efi.mountPoint;
        };
        systemd-boot.enable = true;
      };
    })

    # Boot - GRUB
    (lib.mkIf (cfg.boot.loader == "grub") {
      boot.loader = {
        efi = {
          canTouchEfiVariables = true;
          efiSysMountPoint = cfg.boot.efi.mountPoint;
        };
        systemd-boot.enable = false;
        grub = {
          enable = true;
          device = "nodev";
          useOSProber = cfg.boot.grub.useOSProber;
          efiSupport = true;
        };
      };
    })
  ]);
}
