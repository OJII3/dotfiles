{ ... }: {
  # Assets such as images
  home.file.".dotassets" = {
    source = ../../assets;
    target = ".assets";
  };

  xdg.userDirs.createDirectories = true;
}
