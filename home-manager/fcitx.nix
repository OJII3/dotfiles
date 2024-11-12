{ pkgs, ... }: {
  # home.file.".config/fcitx5" = {
  #   source = ./dotfiles/.config/fcitx5;
  #   recursive = true;
  # };
  home.packages = with pkgs; [
    skkDictionaries.l
    skktools
  ];

  home.file.".config/libskk" = {
    source = ./dotfiles/.config/libskk;
    recursive = true;
  };
}
