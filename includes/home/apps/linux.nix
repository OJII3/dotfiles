{ pkgs, pkgs-stable, ... }:
let
  chromeAvailable = pkgs.system == "x86_64-linux" || pkgs.system == "aarch64-darwin";
  chromeArgs = [
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
    (bottles.override { removeWarningPopup = true; })
    cloudflared
    evince
    figma-linux
    gdlauncher-carbon
    gimp
    hunspell
    hyprpicker
    inkscape-with-extensions
    kdePackages.wrapQtAppsHook
    krita
    libreoffice-qt
    moonlight-qt
    mpv
    nautilus
    nautilus-python
    ocs-url
    overskride
    # pkgs-stable.parsec-bin
    vlc
    warp-terminal
    wineWowPackages.staging
  ];

  programs = {
    vscode.enable = true;
    google-chrome.enable = chromeAvailable;
    chromium.enable = !chromeAvailable;
    firefox.enable = true;
    google-chrome.commandLineArgs = chromeArgs;
    chromium.commandLineArgs = chromeArgs;
  };

  # Partialy Support Plasma Browser Integration
  home.file.".config/google-chrome/NativeMessagingHosts/org.kde.plasma.browser_integration.json" = {
    source = "${pkgs.kdePackages.plasma-browser-integration}/etc/chromium/native-messaging-hosts/org.kde.plasma.browser_integration.json";
  };

  home.file.".local/share/applications/org.kde.plasma.browser_integration.desktop" = {
    source = "${pkgs.kdePackages.plasma-browser-integration}/share/applications/org.kde.plasma.browser_integration.desktop";
  };
}
