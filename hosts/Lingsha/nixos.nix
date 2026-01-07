# Lingsha - Laptop (AMD GPU, ThinkPad, Hyprland, Fingerprint)
#
{ pkgs, ... }:
{
  imports = [
    # Main module with options
    ../../modules/nixos

    ./hardware-configuration.nix
  ];

  # ===== Options-based configuration =====
  my = {
    core = {
      enable = true;
      boot.loader = "systemd-boot";
      virtualisation.podman.enable = true;
    };

    networking = {
      networkManager.enable = true;
      firewall.ros2.enable = true;
      warp.enable = true;
    };

    desktop = {
      enable = true;
      hyprland.enable = true;
      fonts.enable = true;
      sunshine.enable = true;
      waydroid.enable = true;
      peripheral.keyboard.enable = true;
      greetd = {
        enable = true;
        greeter = "tuigreet";
      };
    };

    hardware = {
      gpu = "amd";
      thinkpad.enable = true;
      laptop = {
        enable = true;
        power.batteryProfile = true;
        suspend.enable = true;
      };
    };
  };

  # ===== Host-specific configuration =====

  # Kernel
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen;

  # Hardware Specific Options
  boot.kernelParams = [
    "amd_iommmu=on"
    "mem_sleep_default=deep"
  ];
  boot.extraModulePackages = with pkgs; [
    linuxKernel.packages.linux_zen.v4l2loopback
  ];
  boot.kernelModules = [ "v4l2loopback" ];
  boot.extraModprobeConfig = ''
    options rtw89pci disable_aspm_l1=y
    options rtw89pci disable_aspm_l1ss=y
  '';

  # Fingerprint reader
  services.fprintd.enable = true;
  security.pam.services.hyprlock.fprintAuth = true;
  security.pam.services.login.fprintAuth = true;

  # Sunshine output
  services.sunshine.settings.output_name = 1; # HDMI-A-1

  system.stateVersion = "24.05";
}
