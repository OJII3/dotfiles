{
  services.skhd = {
    enable = true;
  };
  home.file.".config/skhd/skhdrc".source = ./skhdrc;
}
