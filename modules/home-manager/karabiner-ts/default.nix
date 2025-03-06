{ ... }: {
  home.file.".config/karabiner/karabiner.json" = {
    source = ./dist/karabiner.json;
    force = true;
  };
}
