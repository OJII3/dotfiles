{ pkgs, ... }: {
  imports = [
    ./common.nix
  ];

  home.packages = with pkgs; [
    scroll-reverser
  ];

  programs = {
    google-chrome = {
      enable = true;
    };
    firefox.enable = true;
  };
}
