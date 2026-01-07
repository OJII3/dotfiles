{ config, lib, pkgs, pkgs-stable, ... }:
let
  cfg = config.my.home.apps.linux;
in
{
  config = lib.mkIf cfg.common.enable {
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
      voicevox
      unityhub
    ];

    programs = {
      obs-studio.enable = true;
      google-chrome = {
        enable = pkgs.stdenv.hostPlatform.system == "x86_64-linux";
        commandLineArgs = [
          "--ozone-platform-hint=auto"
          "--enable-wayland-ime"
        ];
      };
      vivaldi = {
        enable = true;
        commandLineArgs = [
          "--ozone-platform-hint=auto"
          "--enable-wayland-ime"
        ];
      };
    };
  };
}
