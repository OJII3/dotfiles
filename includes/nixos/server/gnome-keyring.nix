{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    gnome-keyring
    libsecret
  ];

  # gnome-keyringをPAMで自動アンロック（非GUI環境対応）
  security.pam.services.login.enableGnomeKeyring = true;

  # SSHやsudoでもkeyringにアクセスできるように
  security.pam.services.sshd.enableGnomeKeyring = true;

  # D-Busでsecret serviceを利用可能に
  services.dbus.packages = [ pkgs.gnome-keyring ];
}
