{ pkgs, ... }: {
  home.packages = with pkgs; [
    bitwarden-desktop
    pinentry-qt
  ];
  programs.rbw = {
    enable = true;
  };
}
