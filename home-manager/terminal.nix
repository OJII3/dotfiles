{ pkgs, ... }: {
  home.packages = with pkgs; [
    kitty
    foot
  ];
  programs.kitty = {
    enable = true;
  };

  home.file.".config/kitty" = {
    source = ./dotfiles/.config/kitty;
    recursive = true;
  };
}
