{ pkgs, ... }: {
  home.packages = with pkgs; [
    playerctl
    wl-clipboard
  ];
  home.file."~/.config/hypr" = {
    source = ./hypr;
    recursive = true;
  };
}
