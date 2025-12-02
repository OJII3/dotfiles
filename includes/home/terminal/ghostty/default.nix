{ pkgs, ... }:
{
  imports = [ ../default.nix ];
  programs.ghostty.enable = true;
  home.file.".config/ghostty" = {
    source = ./.;
    recursive = true;
  };
}
