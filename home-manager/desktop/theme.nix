{ pkgs, ... }: {
  gtk = {
    enable = true;
    theme = {
      package = pkgs.canta-theme;
      name = "Canta-dark";
    };
    cursorTheme = {
      name = "miku-cursor-linux";
      size = 42;
    };
    iconTheme = {
      # package = pkgs.tau-hydrogen;
      name = "Canta";
    };
  };

  qt = {
    enable = true;
    style.name = "kvantum";
  };
}

