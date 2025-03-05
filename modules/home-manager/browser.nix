{ pkgs, ... }:
let
  isMac = pkgs.system == "aarch64-darwin";
  isChromeAvailable = pkgs.system == "x86_64-linux" || isMac;
  waylandArgs = [
    "--enable-features=UseOzonePlatform"
    "--ozone-platform=wayland"
    "--enable-wayland-ime"
  ];
in
{
  programs = {
    firefox.enable = !isMac;
    google-chrome = {
      enable = isChromeAvailable;
      commandLineArgs =
        if isMac then [ ] else waylandArgs;
    };
    chromium = {
      enable = !isChromeAvailable;
      commandLineArgs = waylandArgs;
    };
  };


  # Plasma Browser Integration
  home.file.".config/google-chrome/NativeMessagingHosts/org.kde.plasma.browser_integration.json" =
    if isMac then {
      text = "";
    } else {
      source = "${pkgs.plasma-browser-integration}/etc/chromium/native-messaging-hosts/org.kde.plasma.browser_integration.json";
    };
  home.file.".local/share/applications/org.kde.plasma.browser_integration.desktop" =
    if isMac then {
      text = "";
    } else {
      source = "${pkgs.plasma-browser-integration}/share/applications/org.kde.plasma.browser_integration.desktop";
    };
}
