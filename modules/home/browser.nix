{ pkgs, ... }:
let
  isChromeAvailable = pkgs.system == "x86_64-linux";
  commandLineArgs = [
    "--ozone-platform-hint=auto"
    "--enable-wayland-ime"
  ];
in
{
  programs = {
    firefox.enable = true;
    google-chrome = {
      enable = isChromeAvailable;
      inherit commandLineArgs;
    };
    chromium = {
      enable = !isChromeAvailable;
      inherit commandLineArgs;
    };
  };


  # Partialy Support Plasma Browser Integration
  home.file.".config/google-chrome/NativeMessagingHosts/org.kde.plasma.browser_integration.json" = {
    source = "${pkgs.kdePackages.plasma-browser-integration}/etc/chromium/native-messaging-hosts/org.kde.plasma.browser_integration.json";
  };

  home.file.".local/share/applications/org.kde.plasma.browser_integration.desktop" = {
    source = "${pkgs.kdePackages.plasma-browser-integration}/share/applications/org.kde.plasma.browser_integration.desktop";
  };
}
