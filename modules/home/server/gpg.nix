{ pkgs, ... }:
{
  programs.gpg.enable = true;
  services.gpg-agent = {
    sshKeys = [ "F99ACACA591A7E19F2199D390F92B2F1474C0D0E" ];
    enable = true;
    enableSshSupport = true;
  };
  services.gpg-agent.pinentry.package = pkgs.pinentry-tty;

  programs.zsh.initContent = ''
    alias pinentry=${pkgs.pinentry-tty}/bin/pinentry
  '';
}
