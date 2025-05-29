{ pkgs, ... }: {
  imports = [ ./. ];
  services.gpg-agent.pinentryPackage = pkgs.pinentry-tty;

  programs.zsh.initContent = ''
    alias pinentry=${pkgs.pinentry-tty}/bin/pinentry
  '';
}
