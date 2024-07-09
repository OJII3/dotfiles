{ pkgs, ... }: {
  programs.obs-studio.enable = true;
  home.packages = with pkgs; [
    yazi
    discord
    discord-ptb
    slack
    parsec-bin
    mate.atril
  ];
}
