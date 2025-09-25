{ pkgs, ... }:
{
  # Assets such as images
  home.file.".assets" = {
    source = ../../assets;
    recursive = true;
  };

  home.packages = with pkgs; [
    nix-search-cli
  ];
}
