{ pkgs, lib, ... }:
{
  services.kdeconnect.enable = true;
  systemd.user.services.kdeconnect.Install.WantedBy = [ "default.target" ];
  systemd.user.services.kdeconnect.Service.ExecStart =
    lib.mkForce "${pkgs.kdePackages.kdeconnect-kde}/bin/kdeconnectd -platform offscreen";
}
