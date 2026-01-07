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
  ]);
}
