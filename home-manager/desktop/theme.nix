{ pkgs, ... }: {
  gtk = {
    enable = true;
    theme = {
      package = pkgs.canta-theme;
      name = "Canta-dark";
    };
  };

  qt = {
    enable = true;
    style.name = "kvantum";
  };
}

