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
  boot.kernelParams = [
    "amd_iommu=on"
    "iommu=pt"
    "split_lock_detect=off"
    "acpi.ec_no_wakeup=1"
  ];
  boot.kernelModules = [ "v4l2loopback" ];

  # zram swap (this machine ships with no swap). zstd compresses ~3:1,
  # giving headroom for gaming + Waydroid without disk paging.
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 100;
  };

  # Hibernate (S4): s2idle resume hangs in firmware on BIOS 1.17, so disk
  # hibernation is the reliable sleep path. zram cannot hold a hibernation
  # image, so a real swapfile on btrfs is required (created as NoCOW by the
  # swap module via `btrfs filesystem mkswapfile`). RAM is 22GiB.
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 24 * 1024;
    }
  ];
  boot.resumeDevice = "/dev/disk/by-uuid/c544cc27-e5b6-4132-8442-4a397fb360ce";
  # resume_offset is determined by the physical location of the swapfile.
  # After the first rebuild creates it, obtain the value with:
  #   sudo btrfs inspect-internal map-swapfile -r /var/lib/swapfile
  # and add "resume_offset=<value>" to boot.kernelParams above.
  # If the swapfile is ever recreated (e.g. size change), the offset changes.

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
