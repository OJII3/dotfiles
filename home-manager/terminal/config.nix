{ ... }: {
  home.file.".config/kitty" = {
    source = .config/kitty;
    recursive = true;
  };
  home.file.".config/ghostty" = {
    source = .config/ghostty;
    recursive = true;
  };
}
