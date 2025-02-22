{ pkgs, ... }: {
  qt.enable = true;
  # qt.platformTheme.name = 
  programs.obs-studio.enable = true;
  home.packages = with pkgs; [
    # logisim-evolution
    # parsec-bin
    # rquickshare
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
    mpv
    nautilus
    nautilus-python
    qtrvsim
    realvnc-vnc-viewer
    slack
    unityhub
    vlc
    wineWowPackages.staging
  ];
}

