{ pkgs, ... }: {
  fonts.packages = with pkgs; [
    hackgen-nf-font
    moralerspace-nf
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    orbitron
  ];
}
