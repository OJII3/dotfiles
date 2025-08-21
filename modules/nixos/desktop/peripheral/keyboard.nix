{ ... }:
{
  services.udev.extraRules = ''
    # Permit all Keychron (VID 3434) on hidraw for VIA
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3434", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
  '';
}
