{
  services.skhd = {
    enable = false;
    config = builtins.readFile ./skhdrc;
  };
}
