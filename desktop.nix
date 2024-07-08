{ pkgs, ... }: {
  home.packages = with pkgs; [
    playerctl
    wl-clipboard
  ];
  # home.file."~/.config/hypr/hyprland.conf".text = builtins.readFile "./hypr/hyprland.conf";
}
