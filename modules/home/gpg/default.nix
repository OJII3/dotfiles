{ config, lib, pkgs, ... }:
let
  cfg = config.my.home;
  pinentryPkg = {
    tty = pkgs.pinentry-tty;
    qt = pkgs.pinentry-qt;
    gnome3 = pkgs.pinentry-gnome3;
  }.${cfg.gpg.pinentryPackage};
in
{
  config = lib.mkIf cfg.gpg.enable {
    programs.gpg.enable = true;
    services.gpg-agent = {
      sshKeys = [ "F99ACACA591A7E19F2199D390F92B2F1474C0D0E" ];
      enable = true;
      enableSshSupport = true;
      pinentry.package = pinentryPkg;
    };

    # TTY mode specific
    programs.zsh.initContent = lib.mkIf (cfg.gpg.pinentryPackage == "tty") ''
      alias pinentry=${pkgs.pinentry-tty}/bin/pinentry
    '';
  };
}
