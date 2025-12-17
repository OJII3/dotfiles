# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }:
{
  imports = [
    ../../includes/nixos/core
    ../../includes/nixos/core/networking
    ../../includes/nixos/core/boot/systemd-boot.nix
    # ../../includes/nixos/core/cloudflare-warp.nix
    # ../../includes/nixos/core/power/laptop.nix
    # ../../includes/nixos/core/suspend
    ../../includes/nixos/core/virtualisation.nix
    ../../includes/nixos/core/networking/networkmanager.nix

    # ../../includes/nixos/desktop
    ../../includes/nixos/desktop/sunshine.nix
    ../../includes/nixos/desktop/bitwarden.nix
    ../../includes/nixos/desktop/fonts.nix
    ../../includes/nixos/desktop/keyd.nix
    ../../includes/nixos/desktop/peripheral/keyboard.nix
    ../../includes/nixos/desktop/peripheral/vr.nix
    ../../includes/nixos/desktop/waydroid.nix

    ./hardware-configuration.nix
  ];

  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Karnel.
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen; # for waydroid

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
  hardware.amdgpu.opencl.enable = true;
  hardware.amdgpu.initrd.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
