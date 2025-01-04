{ pkgs, ... }: {
  home.packages = with pkgs; [
    kitty
    ghostty
  ];
  programs.kitty = {
    enable = true;
  };
  home.file.".config/kitty" = {
    source = ../home/.config/kitty;
    recursive = true;
  };
}
