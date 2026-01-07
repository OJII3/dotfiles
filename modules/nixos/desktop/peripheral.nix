# Peripheral device configuration
{ config, lib, ... }:
let
  cfg = config.my.desktop;
in
{
  config = lib.mkIf cfg.enable (lib.mkMerge [
    # Keychron keyboard udev rules for VIA
    (lib.mkIf cfg.peripheral.keyboard.enable {
      services.udev.extraRules = ''
        # Permit all Keychron (VID 3434) on hidraw for VIA
        KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3434", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
      '';
    })
  ]);
}
