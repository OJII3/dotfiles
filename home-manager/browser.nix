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

  home.packages = with pkgs; [
    kdePackages.plasma-browser-integration
  ];
}
