{
  services.swaync = {
    enable = true;
    settings = builtins.fromJSON ''${builtins.readFile ./config.json}'';
    style = ''
      ${builtins.readFile ./style.css}
    '';
  };
}
