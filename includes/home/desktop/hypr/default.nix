{
  services.hyprpaper.enable = true;
  programs.hyprlock.enable = true;

  home.file.".config/hypr/hyprlock.conf".source = ./hyprlock.conf;
  home.file.".config/hypr/hypridle.conf".source = ./hypridle.conf;
  home.file.".config/hypr/hyprpaper.conf".source = ./hyprpaper.conf;

}
