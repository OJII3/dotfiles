# GNOME desktop environment + Qt theming.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dot.desktop;
in
{
  config = lib.mkMerge [
    # Qt theming for any desktop host
    (lib.mkIf cfg.enable {
      qt = {
        enable = true;
        platformTheme = "qt5ct";
        style = "kvantum";
      };
    })

    # GNOME (GDM + GNOME Shell)
    (lib.mkIf cfg.gnome.enable {
      services.displayManager.gdm.enable = true;
      services.desktopManager.gnome.enable = true;
      environment.gnome.excludePackages = with pkgs; [
        epiphany # browser
        gnome-music
      ];

      assertions = [
        {
          assertion = !cfg.greetd.enable;
          message = "dot.desktop.gnome.enable と dot.desktop.greetd.enable は同時に有効化できません (GDM と greetd が競合します)。";
        }
      ];
    })
  ];
}
