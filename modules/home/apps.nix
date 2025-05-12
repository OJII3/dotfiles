{ pkgs, ... }: {
  qt.enable = true;
  programs.obs-studio.enable = true;
  home.packages = with pkgs; [
    blender
    bottles
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
    jetbrains-toolbox
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
    unityhub
    vlc
    warp-terminal
    wineWowPackages.staging
  ];
}

