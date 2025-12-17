{ pkgs, ... }:
{
  imports = [
    ../../gpg/gnome.nix
  ];
  qt.enable = true;

  home.packages =
    with pkgs;
    [
      kdePackages.wrapQtAppsHook
    ]
    ++ (with pkgs.gnomeExtensions; [
      blur-my-shell
      caffeine
      gsconnect
      kimpanel
    ]);
}
