{ pkgs, pkgs-stable, ... }: {
  home.packages = [
    pkgs-stable.colloid-icon-theme
    pkgs-stable.colloid-gtk-theme
  ];

  gtk = {
    enable = true;
    theme = {
      package = pkgs.canta-theme;
      name = "Colloid";
    };
    cursorTheme = {
      name = "miku-cursor-linux";
      size = 36;
    };
    iconTheme = {
      # package = pkgs.tau-hydrogen;
      name = "Colloid";
    };
  };

  qt = {
    enable = true;
    style.name = "kvantum";
  };

  services.darkman = {
    enable = true;
  };
}

