{ pkgs, pkgs-stable, ... }:
{
  imports = [
    ../common.nix
  ];

  home.packages = with pkgs; [
    (bottles.override { removeWarningPopup = true; })
    discord
    figma-linux
    gimp
    hunspell
    inkscape-with-extensions
    krita
    moonlight-qt
    mpv
    obsidian
    pkgs-stable.blender
    vlc
    voicevox
    unityhub
  ];

  programs = {
    obs-studio.enable = true;
    google-chrome.enable = pkgs.stdenv.hostPlatform.system == "x86_64-linux";
    firefox.enable = true;
    google-chrome.commandLineArgs = [
      "--ozone-platform-hint=auto"
      "--enable-wayland-ime"
    ];
  };
}
