{
  config,
  lib,
  pkgs,
  pkgs-stable,
  ...
}:
let
  cfg = config.dot.home.desktop;
in
{
  config = lib.mkIf cfg.theme.enable {
    home.packages = with pkgs; [
      ocs-url
    ];

    gtk = {
      enable = true;
      theme = {
        package = pkgs-stable.colloid-gtk-theme;
        name = "Colloid-Dark";
      };
      cursorTheme = {
        package = pkgs.afterglow-cursors-recolored;
        name = "Afterglow-Recolored-Catppuccin-Pink";
        size = 36;
      };
      iconTheme = {
        package = pkgs-stable.colloid-icon-theme;
        name = "Colloid-Dark";
      };
    };

    qt = {
      enable = true;
    };
  };
}
