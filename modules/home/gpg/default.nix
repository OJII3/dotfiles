{ pkgs, ... }: {
  home.packages = with pkgs; [
    pinentry-tty
  ];

  programs.gpg.enable = true;
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
  };
}
