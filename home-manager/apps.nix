{ pkgs, ... }: {
  programs.obs-studio.enable = true;
  home.packages = with pkgs; [
    discord
    discord-ptb
    slack
    parsec-bin
    mate.atril
    lutris
    unityhub
    blender
    gimp
    mpv
  ];
}
