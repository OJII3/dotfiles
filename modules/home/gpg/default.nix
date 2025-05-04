{ ... }: {
  programs.gpg.enable = true;
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
  };

  programs.zsh.initExtra = ''
    export GPG_TTY=$(tty)
  '';
}
