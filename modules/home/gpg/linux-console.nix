{ pkgs, ... }: {
  imports = [
    ./.
  ];

  services.gpg-agent.pinentryPackage = pkgs.pinentry-tty;
  programs.zsh.initExtra = ''
    export GPG_TTY=$(tty)
  '';
}
