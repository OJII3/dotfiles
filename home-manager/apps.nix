{ pkgs, ... }: {
  qt.enable = true;
  # qt.platformTheme.name = 
  programs.obs-studio.enable = true;
  home.packages = with pkgs; [
    blender
    bottles
    cloudflared
    discord
    evince
    figma-linux
    gimp
    hunspell
    hyprpicker
    inkscape-with-extensions
    jetbrains-toolbox
    kdePackages.kdeconnect-kde
    kdePackages.wrapQtAppsHook
    libreoffice-qt
    logisim-evolution
    mpv
    nautilus
    parsec-bin
    qtrvsim
    realvnc-vnc-viewer
    rquickshare
    slack
    unityhub
    vlc
    wineWowPackages.staging
    xournalpp
  ];
}

