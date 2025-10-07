{ pkgs, ... }:
{
  imports = [
    ./common.nix
  ];

  home.packages =
    with pkgs;
    [
      appcleaner
      scroll-reverser
      terminal-notifier
    ]
    ++ (with pkgs.brewCasks; [

      blockbench
      chatgpt
      figma
      firefox
      ghostty
      moonlight
      obs
      pngpaste

      (unity-hub.overrideAttrs (oldAttrs: {
        src = pkgs.fetchurl {
          url = builtins.head oldAttrs.src.urls;
          hash = "sha256-1SrVqyGjgOko2rpNsCR0ZL6+7Xbgu2M8itSJeQ8+0Ic=";
        };
      }))
    ]);
}
