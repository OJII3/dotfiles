# greetd によるヘッドレス自動ログイン。
{ config, lib, ... }:
let
  cfg = config.dot.server;
in
{
  config = lib.mkIf (cfg.enable && cfg.autologin.enable) {
    services.greetd = {
      enable = true;
      settings = rec {
        initial_session = {
          command = cfg.autologin.shell;
          user = cfg.autologin.user;
        };
        default_session = initial_session;
      };
    };
  };
}
