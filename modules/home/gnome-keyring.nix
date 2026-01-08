{ config, lib, pkgs, ... }:
let
  cfg = config.dot.home;
in
{
  config = lib.mkIf cfg.gnomeKeyring.enable {
    home.packages = with pkgs; [
      gnome-keyring
      libsecret
    ];

    services.gnome-keyring = {
      enable = true;
      components = [
        "secrets"
        "pkcs11"
      ];
    };

    systemd.user.services.gnome-keyring = {
      Install = {
        WantedBy = [ "default.target" ];
      };
    };
  };
}
