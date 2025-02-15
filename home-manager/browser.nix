{ pkgs, ... }: {
  programs = {
    firefox.enable = true;
    google-chrome = {
      enable = true;
      commandLineArgs = [
        "--enable-features=UseOzonePlatform"
        "--ozone-platform=wayland"
        "--enable-wayland-ime"
      ];
    };
  };

  home.file.".config/google-chrome/NativeMessagingHosts/org.kde.plasma.browser_integration.json" = {
    source = "${pkgs.plasma-browser-integration}/etc/chromium/native-messaging-hosts/org.kde.plasma.browser_integration.json";
  };
  home.file.".local/share/applications/org.kde.plasma.browser_integration.desktop" = {
    source = "${pkgs.plasma-browser-integration}/share/applications/org.kde.plasma.browser_integration.desktop";
  };
}
