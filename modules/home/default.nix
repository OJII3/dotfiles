{ ... }: {
  # Assets such as images
  home.file.".assets" = {
    source = ../../assets;
    recursive = true;
  };

  xdg.userDirs.createDirectories = true;
}
