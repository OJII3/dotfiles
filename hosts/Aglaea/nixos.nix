# Aglaea - Desktop (AMD GPU, GNOME, ThinkPad)
#
{ pkgs, ... }:
{
  imports = [
    ../../modules/nixos
    ./hardware-configuration.nix
  ];

  # ===== Options-based configuration =====
  dot = {
    core = {
      enable = true;
      boot.loader = "systemd-boot";
      virtualisation.podman.enable = true;
    };

    networking = {
      firewall.enable = false;
      networkManager.enable = true;
      warp.enable = false;
    };

    desktop = {
      enable = true;
      gnome.enable = true;
      fonts.enable = true;
      keyd.enable = true;
      sunshine.enable = true;
      waydroid.enable = true;
      peripheral.keyboard.enable = true;
      androidDev.enable = true;
      bitwarden.enable = true;
      gaming = {
        enable = true;
        vr.enable = true;
      };
    };

    hardware = {
      gpu = "amd";
      thinkpad.enable = true;
    };
  };

  # ===== Host-specific configuration =====

  # Kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Hardware Specific Options
  # (acpi_backlight / thinkpad_acpi.fan_control are provided by dot.hardware.thinkpad)
  boot.kernelParams = [
    # Hardware IOMMU with passthrough mapping (minimal DMA overhead).
    # Was previously "iommu=soft" (swiotlb bounce buffers, slow); the old
    # "amd_iommmu=on" was a typo (3 m's) and never took effect.
    "amd_iommu=on"
    "iommu=pt"
    # Avoid massive slowdowns in Proton/Windows games that trigger split-lock detection.
    "split_lock_detect=off"
  ];
  boot.kernelModules = [ "v4l2loopback" ];

  # zram swap (this machine ships with no swap). zstd compresses ~3:1,
  # giving headroom for gaming + Waydroid without disk paging.
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 100;
  };

  # VM tuning for zram-backed swap (fast, in-memory) and desktop responsiveness.
  boot.kernel.sysctl = {
    "vm.swappiness" = 180; # zram is cheap, prefer it over reclaiming caches
    "vm.page-cluster" = 0; # no readahead: zram has no seek penalty
    "vm.watermark_boost_factor" = 0;
    "vm.watermark_scale_factor" = 125;
  };

  # btrfs: noatime + transparent zstd compression (level 1 stays fast on NVMe).
  fileSystems."/".options = [
    "noatime"
    "compress=zstd:1"
  ];

  # sched_ext: scx_lavd is tuned for low-latency interactive/gaming workloads.
  services.scx = {
    enable = true;
    scheduler = "scx_lavd";
  };

  # GameMode: applies CPU governor / scheduling tweaks while games run.
  programs.gamemode.enable = true;

  system.stateVersion = "24.05";
}
