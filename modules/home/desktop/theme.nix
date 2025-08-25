{ pkgs, pkgs-stable, ... }: {
  gtk = {
    enable = true;
    theme = {
      package = pkgs-stable.colloid-gtk-theme;
      name = "Colloid";
    };
    cursorTheme = {
      name = "miku-cursor-linux";
      size = 36;
    };
    iconTheme = {
      package = pkgs-stable.colloid-icon-theme;
      name = "Colloid";
    };
  };

  qt = {
    enable = true;
    style.package = pkgs-stable.colloid-kde;
    style.name = "kvantum";
  };

  services.darkman = {
    enable = true;
  };
}

