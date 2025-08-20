{
  services.swaync = {
    enable = true;
    settings = builtins.fromJSON ''${builtins.readFile ./config.json}'';
    style = ''
      ${builtins.readFile ./style.scss}
      ${builtins.readFile ./widgets/buttons.scss}
      ${builtins.readFile ./widgets/label.scss}
      ${builtins.readFile ./widgets/menubar.scss}
      ${builtins.readFile ./widgets/mpris.scss}
      ${builtins.readFile ./widgets/slider.scss}
      ${builtins.readFile ./widgets/title.scss}
      ${builtins.readFile ./widgets/volume.scss}
    '';
  };
}
