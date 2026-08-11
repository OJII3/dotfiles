# NixOS Server modules
# オプション定義は ./options.nix、各機能は同階層の実装ファイルに分割している。
# 実装ファイルは自身の dot.server.* オプションで lib.mkIf ゲートする。
{ ... }:
{
  imports = [
    ./options.nix
    ./adguard-home.nix
    ./autologin.nix
    ./gnome-keyring.nix
    ./librenms.nix
    ./minecraft.nix
    ./observability
    ./postgresql.nix
    ./zabbix.nix
  ];
}
