{ pkgs, ... }: {
  fonts.packages = with pkgs; [
    hackgen-nf-font
    moralerspace
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    orbitron
  ];
}
