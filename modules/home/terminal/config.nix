{ pkgs, ... }: {
  home.packages = with pkgs; [
    hackgen-nf-font
  ];
  home.file.".config/kitty" = {
    source = ./config/kitty;
    recursive = true;
  };
  home.file.".config/ghostty" = {
    source = ./config/ghostty;
    recursive = true;
  };
}
