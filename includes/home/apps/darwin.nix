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
          hash = "sha256-fiF5NxZLzNv/x4e83HV/OI2UrgFY6jL4YPExU53SWok=";
        };
      }))
    ]);
}
