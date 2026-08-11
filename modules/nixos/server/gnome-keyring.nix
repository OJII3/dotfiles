# ヘッドレス環境向けの GNOME Keyring (Secret Service)。
# GUI セッションがないため PAM 経由で自動アンロックする。
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dot.server;
in
{
  config = lib.mkIf (cfg.enable && cfg.gnomeKeyring.enable) {
    environment.systemPackages = with pkgs; [
      gnome-keyring
      libsecret
    ];

    security.pam.services.login.enableGnomeKeyring = true;
    security.pam.services.sshd.enableGnomeKeyring = true;

    services.dbus.packages = [ pkgs.gnome-keyring ];
  };
}
