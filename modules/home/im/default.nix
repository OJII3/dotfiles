{ pkgs, ... }: {
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      fcitx5-mozc
      fcitx5-gtk
      fcitx5-skk
    ];
    # fcitx5.settings.inputMethod = {
    #   GroupOrder."0" = "Default";
    #   "Groups/0" = {
    #     Name = "Default";
    #     "Default Layout" = "us";
    #     DefaultIm = "skk";
    #   };
    #   "Groups/0/Items/0" = {
    #     Name = "keyboard-us";
    #   };
    #   "Groups/0/Items/1" = {
    #     Name = "skk";
    #   };
    # };
  };

  # home.file.".config/fcitx5/profile" = {
  #   source = ./config/fcitx5/profile;
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
