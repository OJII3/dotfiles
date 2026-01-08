# NixOS Hardware modules
# Hardware-specific configuration with customizable options.
#
# Options:
#   dot.hardware.gpu           - GPU type: "amd", "nvidia", "intel", or null
#   dot.hardware.nvidia.*      - NVIDIA-specific options (Prime, etc.)
#   dot.hardware.thinkpad.enable - Enable ThinkPad-specific settings
#   dot.hardware.laptop.enable - Enable laptop power management
#
{ config, lib, pkgs, ... }:
let
  cfg = config.dot.hardware;
in
{
  options.dot.hardware = {
    gpu = lib.mkOption {
      type = lib.types.nullOr (lib.types.enum [ "amd" "nvidia" "intel" ]);
      default = null;
      description = "GPU type for driver configuration";
    };

    nvidia = {
      prime = {
        enable = lib.mkEnableOption "NVIDIA Prime (hybrid graphics)";

        offload = {
          enable = lib.mkEnableOption "NVIDIA Prime offload mode" // {
            default = true;
          };
        };

        sync = {
          enable = lib.mkEnableOption "NVIDIA Prime sync mode";
        };

        intelBusId = lib.mkOption {
          type = lib.types.str;
          default = "PCI:0:2:0";
          description = "Intel GPU PCI bus ID";
        };

        nvidiaBusId = lib.mkOption {
          type = lib.types.str;
          default = "PCI:1:0:0";
          description = "NVIDIA GPU PCI bus ID";
        };
      };

      open = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Use open source NVIDIA kernel module";
      };
    };

    thinkpad = {
      enable = lib.mkEnableOption "ThinkPad-specific settings";

      fanControl = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable thinkfan control";
      };
    };

    laptop = {
      enable = lib.mkEnableOption "laptop power management";

      power = {
        tuned = {
          enable = lib.mkEnableOption "tuned power management" // {
            default = true;
          };
        };
        batteryProfile = lib.mkEnableOption "laptop battery power profile";
      };

      suspend = {
        enable = lib.mkEnableOption "suspend/hibernate configuration";
        hibernateDelay = lib.mkOption {
          type = lib.types.str;
          default = "600s";
          description = "Delay before hibernate after suspend";
        };
      };
    };
  };

  config = lib.mkMerge [
    # AMD GPU
    (lib.mkIf (cfg.gpu == "amd") {
      services.xserver.videoDrivers = [ "amdgpu" ];
      hardware.amdgpu.opencl.enable = true;
      hardware.amdgpu.initrd.enable = true;
    })

    # NVIDIA GPU
    (lib.mkIf (cfg.gpu == "nvidia") {
      services.xserver.videoDrivers = [ "nvidia" ];
      hardware.nvidia = {
        modesetting.enable = true;
        powerManagement.enable = false;
        powerManagement.finegrained = false;
        open = cfg.nvidia.open;
        nvidiaSettings = true;
      };
    })

    # NVIDIA Prime
    (lib.mkIf (cfg.gpu == "nvidia" && cfg.nvidia.prime.enable) {
      hardware.nvidia.prime = {
        offload = lib.mkIf cfg.nvidia.prime.offload.enable {
          enable = true;
          enableOffloadCmd = true;
        };
        sync = lib.mkIf cfg.nvidia.prime.sync.enable {
          enable = true;
        };
        intelBusId = cfg.nvidia.prime.intelBusId;
        nvidiaBusId = cfg.nvidia.prime.nvidiaBusId;
      };
    })

    # Intel GPU
    (lib.mkIf (cfg.gpu == "intel") {
      services.xserver.videoDrivers = [ "intel" ];
    })

    # ThinkPad
    (lib.mkIf cfg.thinkpad.enable (lib.mkMerge [
      {
        boot.kernelParams = [
          "acpi_backlight=native"
          "thinkpad_acpi.fan_control=1"
        ];
      }
      (lib.mkIf cfg.thinkpad.fanControl {
        services.thinkfan = {
          enable = true;
          smartSupport = true;
        };
      })
    ]))

    # Laptop power management - base
    (lib.mkIf cfg.laptop.enable {
      services.upower.enable = true;
    })

    # Laptop power management - tuned
    (lib.mkIf (cfg.laptop.enable && cfg.laptop.power.tuned.enable) {
      services.tuned = {
        enable = true;
        settings.dynamic_tuning = true;
        ppdSupport = true;
      };
    })

    # Laptop power management - battery profile
    (lib.mkIf (cfg.laptop.enable && cfg.laptop.power.batteryProfile) {
      services.tuned.ppdSettings.battery = {
        balanced = "laptop-battery-powersave";
      };
    })

    # Laptop suspend/hibernate
    (lib.mkIf (cfg.laptop.enable && cfg.laptop.suspend.enable) {
      systemd.sleep.extraConfig = ''
        AllowSuspend=yes
        AllowHibernation=yes
        AllowHybridSleep=yes
        AllowSuspendThenHibernate=yes
        HibernateDelaySec=${cfg.laptop.suspend.hibernateDelay}
        SuspendState=mem
      '';
    })
  ];
}
