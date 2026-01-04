{ pkgs, ... }:
{
  home.packages = with pkgs; [
    gnome-keyring
    libsecret
  ];

  # gnome-keyringデーモンをユーザーセッションで起動
  services.gnome-keyring = {
    enable = true;
    components = [
      "secrets"
      "pkcs11"
    ];
  };

  # 非GUI環境でも起動するようにdefault.targetに変更
  systemd.user.services.gnome-keyring = {
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
