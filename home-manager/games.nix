{ inputs, pkgs, ... }: {
  home.packages = [ inputs.aagl.packages.${pkgs.system}.honkers-launcher ];
}
