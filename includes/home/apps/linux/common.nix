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
    pkgs-stable.blender
    vlc
  ];

  programs = {
    obs-studio.enable = true;
    vscode.enable = true;
    google-chrome.enable = pkgs.system == "x86_64-linux";
    firefox.enable = true;
    google-chrome.commandLineArgs = [
      "--ozone-platform-hint=auto"
      "--enable-wayland-ime"
    ];
  };
}
