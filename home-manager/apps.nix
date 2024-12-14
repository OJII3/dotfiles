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
    nautilus
    vlc
    figma-linux
    logisim-evolution
    qtrvsim
    hyprpicker
    bottles
    wineWowPackages.staging
  ];
}

