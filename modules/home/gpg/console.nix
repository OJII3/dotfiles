{ pkgs, ... }:
{
  imports = [ ./. ];
  services.gpg-agent.pinentry.package = pkgs.pinentry-tty;

  programs.zsh.initContent = ''
    alias pinentry=${pkgs.pinentry-tty}/bin/pinentry
  '';
}
