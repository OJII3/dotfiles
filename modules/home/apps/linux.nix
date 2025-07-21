{ pkgs, ... }:
let
  isChromeAvailable = pkgs.system == "x86_64-linux";
  commandLineArgs = [
    "--ozone-platform-hint=auto"
    "--enable-wayland-ime"
  ];
in
{
  imports = [
    ./common.nix
  ];

  qt.enable = true;
  programs.obs-studio.enable = true;
  home.packages = with pkgs; [
    bottles
    cloudflared
    evince
    figma-linux
    gdlauncher-carbon
    gimp
    hunspell
    hyprpicker
    inkscape-with-extensions
    kdePackages.wrapQtAppsHook
    libreoffice-qt
    moonlight-qt
    mpv
    nautilus
    nautilus-python
    ocs-url
    parsec-bin
    vlc
    warp-terminal
    wineWowPackages.staging
  ];

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

