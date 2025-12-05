{ pkgs, pkgs-stable, ... }:
{
  home.packages = with pkgs; [
    ocs-url # For installing icon themes from .ocf files
  ];

  gtk = {
    enable = true;
    theme = {
      package = pkgs-stable.colloid-gtk-theme;
      name = "Colloid-Dark";
    };
    cursorTheme = {
      name = "miku-cursor-linux";
      size = 36;
    };
    iconTheme = {
      package = pkgs-stable.colloid-icon-theme;
      name = "Colloid-Dark";
    };
  };

  qt = {
    enable = true;
    style.package = pkgs.kdePackages.qt6gtk2;
    style.name = "gtk2";
  };

  services.darkman = {
    enable = true;
  };
}
