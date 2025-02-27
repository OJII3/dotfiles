{ pkgs, ... }: {
  fonts.packages = with pkgs; [
    hackgen-nf-font
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    orbitron
  ];
}
