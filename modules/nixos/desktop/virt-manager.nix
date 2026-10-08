# virt-manager with a local libvirt/QEMU backend
{ config, lib, ... }:
let
  cfg = config.dot.desktop;
in
{
  config = lib.mkIf (cfg.enable && cfg.virtManager.enable) {
    virtualisation.libvirtd.enable = true;
    programs.virt-manager.enable = true;
    users.users.${config.dot.core.user.name}.extraGroups = [ "libvirtd" ];
  };
}
