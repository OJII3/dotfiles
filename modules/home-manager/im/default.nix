{ pkgs, ... }: {
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      fcitx5-mozc
      fcitx5-gtk
      fcitx5-skk
    ];
  };

  # home.file.".config/fcitx5" = {
  #   source = ./dotfiles/.config/fcitx5;
  #   recursive = true;
  # };
  home.packages = with pkgs; [
    skkDictionaries.l
    skktools
  ];

  home.file.".config/libskk" = {
    source = ./config/libskk;
    recursive = true;
  };
}
