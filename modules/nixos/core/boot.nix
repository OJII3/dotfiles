# Boot loader: systemd-boot / GRUB.
{ config, lib, ... }:
let
  cfg = config.dot.core;
in
{
  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      # systemd-boot
      (lib.mkIf (cfg.boot.loader == "systemd-boot") {
        boot.loader = {
          efi = {
            canTouchEfiVariables = true;
            efiSysMountPoint = cfg.boot.efi.mountPoint;
          };
          systemd-boot.enable = true;
        };
      })

      # GRUB
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
    ]
  );
}
