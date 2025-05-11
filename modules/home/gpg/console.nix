{ pkgs, ... }: {
  imports = [ ./. ];
  services.gpg-agent.pinentryPackage = pkgs.pinentry-tty;

  programs.zsh.initExtra = ''
    alias pinentry=${pkgs.pinentry-tty}/bin/pinentry
  '';
}
