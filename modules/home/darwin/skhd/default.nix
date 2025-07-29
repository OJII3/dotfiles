{
  services.skhd = {
    enable = true;
    config = builtins.readFile ./skhdrc;
  };
}
