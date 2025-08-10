{ pkgs, pkgs-stable, ... }:
let
  chromeAvailable = pkgs.system == "x86_64-linux" || pkgs.system == "aarch64-darwin";
in
{
  home.packages = with pkgs; [
    # ghostty # broken on darwin
    pkgs-stable.blender
    discord
    jetbrains-toolbox
    slack
    postman
    code-cursor
  ];

  programs = {
    vscode.enable = true;
    google-chrome.enable = chromeAvailable;
    chromium.enable = !chromeAvailable;
    firefox.enable = true;
  };
}

