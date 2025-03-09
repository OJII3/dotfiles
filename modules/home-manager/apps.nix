{ pkgs, ... }: {
  qt.enable = true;
  programs.obs-studio.enable = true;
  home.packages = with pkgs; [
    # parsec-bin
    blender
    bottles
    cloudflared
    discord
    evince
    figma-linux
    gdlauncher-carbon
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
    ocs-url
    qtrvsim
    realvnc-vnc-viewer
    slack
    unityhub
    vlc
    wineWowPackages.staging
  ];
}

