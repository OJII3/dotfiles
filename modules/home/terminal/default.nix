{ pkgs, ... }: {
  imports = [ ../default.nix ];
  home.packages = with pkgs; [
    hackgen-nf-font
  ];
}
