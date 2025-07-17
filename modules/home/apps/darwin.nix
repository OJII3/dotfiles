{ pkgs, ... }: {
  imports = [
    ./common.nix
  ];

  home.packages = with pkgs; [
    scroll-reverser
    utm
    appcleaner
  ];

  programs = {
    google-chrome = {
      enable = true;
    };
    firefox.enable = true;
  };
}
