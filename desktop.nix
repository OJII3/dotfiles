{ pkgs, ... }: {
  home.packages = with pkgs; [
    playerctl
    wl-clipboard
  ];
  home.file."~/.config/hypr/hyprland.conf".text = builtins.readFile ./dotfiles/hypr/hyprland.conf;
}
