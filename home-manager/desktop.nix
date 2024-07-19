{ pkgs, ... }: {
  home.packages = with pkgs; [
    hyprpaper
    hyprcursor
    hypridle
    hyprlock
    anyrun
    waybar
    grim
    slurp
    playerctl
    wl-clipboard
    networkmanagerapplet
    swaynotificationcenter
    rose-pine-gtk-theme
    rose-pine-icon-theme
  ];
  programs.waybar = {
    enable = true;
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

