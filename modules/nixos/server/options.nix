# dot.server.* の基本オプション。
# 個別サービスのオプションは各実装ファイル側で定義する。
{
  lib,
  username ? "ojii3",
  ...
}:
{
  options.dot.server = {
    enable = lib.mkEnableOption "server configuration";

    autologin = {
      enable = lib.mkEnableOption "auto-login via greetd";

      user = lib.mkOption {
        type = lib.types.str;
        default = username;
        description = "User for auto-login";
      };

      shell = lib.mkOption {
        type = lib.types.str;
        default = "zsh";
        description = "Shell to start on login";
      };
    };

    adguardHome.enable = lib.mkEnableOption "AdGuard Home DNS server";

    gnomeKeyring.enable = lib.mkEnableOption "GNOME Keyring for headless/non-GUI servers";
  };
}
