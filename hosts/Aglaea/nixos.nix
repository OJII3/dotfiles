# Aglaea - Desktop (AMD GPU, GNOME, ThinkPad)
#
{ pkgs, ... }:
{
  imports = [
    # Main module with options
    ../../modules/nixos

    # Not yet optionized
    ../../modules/nixos/core/boot/systemd-boot.nix
    ../../modules/nixos/core/networking
    ../../modules/nixos/core/networking/networkmanager.nix
    ../../modules/nixos/core/virtualisation/podman.nix
    ../../modules/nixos/desktop/bitwarden.nix
    ../../modules/nixos/desktop/peripheral/keyboard.nix

    ./hardware-configuration.nix
  ];

  # ===== Options-based configuration =====
  my = {
    core.enable = true;

    desktop = {
      enable = true;
      fonts.enable = true;
      keyd.enable = true;
      sunshine.enable = true;
      waydroid.enable = true;
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

  # ===== Desktop Environment (not yet optionized) =====
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # ===== Host-specific configuration =====

  # Kernel
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen;

  # Hardware Specific Options
  boot.kernelParams = [
    "amd_iommmu=on"
    "mem_sleep_default=deep"
    "acpi_backlight=native"
    "thinkpad_acpi.fan_control=1"
  ];
  boot.extraModulePackages = with pkgs; [
    linuxKernel.packages.linux_zen.v4l2loopback
  ];
  boot.kernelModules = [ "v4l2loopback" ];

  system.stateVersion = "24.05";
}
