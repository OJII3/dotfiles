{ config, lib, pkgs, ... }:
let
  cfg = config.my.home.apps.linux;
in
{
  config = lib.mkIf cfg.hyprland.enable {
    qt.enable = true;
    home.packages = with pkgs; [
      evince
      kdePackages.wrapQtAppsHook
      nautilus
      nautilus-python
      overskride
      unityhub
    ];

    programs.vscode.enable = true;

    # Partialy Support Plasma Browser Integration
    home.file.".config/google-chrome/NativeMessagingHosts/org.kde.plasma.browser_integration.json" = {
      source = "${pkgs.kdePackages.plasma-browser-integration}/etc/chromium/native-messaging-hosts/org.kde.plasma.browser_integration.json";
    };

    home.file.".local/share/applications/org.kde.plasma.browser_integration.desktop" = {
      source = "${pkgs.kdePackages.plasma-browser-integration}/share/applications/org.kde.plasma.browser_integration.desktop";
    };
  };
}
