{ pkgs, ... }: {
  home.packages = with pkgs; [
    kitty
  ];
  programs.kitty = {
    enable = true;
  };

  home.file.".config/kitty" = {
    source = ./dotfiles/.config/kitty;
    recursive = true;
  };
}
