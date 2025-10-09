{ pkgs, ... }:
{
  imports = [ ../default.nix ];
  programs.ghostty.enable = !pkgs.stdenv.isDarwin;
  home.file.".config/ghostty" = {
    source = ./.;
    recursive = true;
  };
}
