{ pkgs, ... }: {
  qt.enable = true;
  # qt.platformTheme.name = 
  programs.obs-studio.enable = true;
  home.packages = with pkgs; [
    discord
    # discord-ptb
    slack
    parsec-bin
    evince
    totem
    lutris
    unityhub
    blender
    gimp
    mpv
    inkscape-with-extensions
    realvnc-vnc-viewer
    jetbrains-toolbox
    cloudflared
    kdePackages.wrapQtAppsHook
    kdePackages.kdeconnect-kde
    rquickshare
    xournalpp
    libreoffice-qt
    hunspell
    xfce.thunar
    gpu-screen-recorder-gtk
    vlc
    figma-linux
    logisim-evolution
    qtrvsim
    hyprpicker
  ];
}
