{ lib, ... }: {
  programs.anyrun = {
    enable = true;
    extraCss = builtins.readFile ./style.css;
    config.plugins = [ ];
    extraConfigFiles = {
      "randr.ron".text = builtins.readFile ./randr.ron;
      "websearch.ron".text = builtins.readFile ./websearch.ron;
    };
  };
  xdg.configFile = lib.mkMerge [
    {
      "anyrun/config.ron".text = lib.mkForce (builtins.readFile ./config.ron);
    }
  ];
}

