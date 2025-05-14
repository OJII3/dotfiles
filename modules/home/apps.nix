{ pkgs, ... }: {
  qt.enable = true;
  programs.obs-studio.enable = true;
  home.packages = with pkgs; [
    blender
    cloudflared
    code-cursor
    discord
    evince
    figma-linux
    gdlauncher-carbon
    gimp
    hunspell
    hyprpicker
    inkscape-with-extensions
    kdePackages.wrapQtAppsHook
    libreoffice-qt
    moonlight-qt
    mpv
    nautilus
    nautilus-python
    ocs-url
    parsec-bin
    qtrvsim
    realvnc-vnc-viewer
    slack
    vlc
    warp-terminal
    wineWowPackages.staging
  ];
}

