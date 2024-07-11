{ pkgs, ... }: {
  home.packages = with pkgs; [
    hyprpaper
    hyprcursor
    hypridle
    hyprlock
    anyrun
    waybar
    grim
    playerctl
    wl-clipboard
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
}
