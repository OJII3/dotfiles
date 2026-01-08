{ config, lib, pkgs, ... }:
let
  cfg = config.dot.home.desktop;
in
{
  config = lib.mkIf cfg.anyrun.enable {
    home.packages = with pkgs; [
      rink
    ];
    programs.anyrun = {
      enable = true;
      extraCss = builtins.readFile ./style.css;
      config.plugins = [ ];
      extraConfigFiles = {
        "applications.ron".text = builtins.readFile ./applications.ron;
        "randr.ron".text = builtins.readFile ./randr.ron;
        "websearch.ron".text = builtins.readFile ./websearch.ron;
        "nix-run.ron".text = builtins.readFile ./nix-run.ron;
      };
    };
    xdg.configFile = lib.mkMerge [
      {
        "anyrun/config.ron".text = lib.mkForce (builtins.readFile ./config.ron);
      }
    ];
  };
}
