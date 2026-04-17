# Android development support (adb, udev rules)
{ config, lib, pkgs, ... }:
let
  cfg = config.dot.desktop;
in
{
  config = lib.mkIf (cfg.enable && cfg.androidDev.enable) {
    environment.systemPackages = [ pkgs.android-tools ];

    # Meta Quest devices (VID 2833) are not covered by systemd's built-in
    # uaccess rules. TAG+="uaccess" grants access to the active console user.
    services.udev.extraRules = ''
      SUBSYSTEM=="usb", ATTR{idVendor}=="2833", MODE="0660", TAG+="uaccess"
    '';
  };
}
