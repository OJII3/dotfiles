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
    lutris
    unityhub
    blender
    gimp
    mpv
    realvnc-vnc-viewer
    gnome-keyring
    cloudflare-warp
    cloudflared
    kdePackages.kdeconnect-kde
    rquickshare
    xournalpp
    xfce.thunar
  ];
}
