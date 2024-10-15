{ pkgs, ... }: {
  home.packages = with pkgs; [
    hyprpaper
    # hyprcursor # prefer using gtk cursor
    hypridle
    hyprlock
    anyrun
    waybar
    grim
    slurp
    playerctl
    wl-clipboard
    nwg-displays
    networkmanagerapplet
    swaynotificationcenter
    rose-pine-gtk-theme
    rose-pine-icon-theme
  ];
  programs.waybar = {
    enable = true;
  };

  home.file.".config/kwalletrc".text = ''
    [Wallet]
    Default Wallet=kdewallet
    First Use=false

    [org.freedesktop.secrets]
    apiEnabled=true
    autoStart=true
  '';
  home.file.".local/share/dbus-1/services/org.freedesktop.secrets.service" = {
    text = ''
      [D-BUS Service]
      Name=org.freedesktop.secrets
      Exec=${pkgs.kdePackages.kwallet}/bin/kwalletd6
    '';
  };

  home.file.".config/hypr" = {
    source = ./dotfiles/.config/hypr;
    recursive = true;
  };
  home.file.".config/anyrun" = {
    source = ./dotfiles/.config/anyrun;
    recursive = true;
  };
  home.file.".config/waybar" = {
    source = ./dotfiles/.config/waybar;
    recursive = true;
  };
  home.file.".config/swaync" = {
    source = ./dotfiles/.config/swaync;
    recursive = true;
  };
  home.file.".config/gtk-3.0" = {
    source = ./dotfiles/.config/gtk-3.0;
    recursive = true;
  };
  home.file.".config/gtk-4.0" = {
    source = ./dotfiles/.config/gtk-4.0;
    recursive = true;
  };
}

