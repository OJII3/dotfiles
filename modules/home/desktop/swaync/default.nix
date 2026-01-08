{ config, lib, ... }:
let
  cfg = config.dot.home.desktop;
in
{
  config = lib.mkIf cfg.swaync.enable {
    services.swaync = {
      enable = true;
      settings = builtins.fromJSON ''${builtins.readFile ./config.json}'';
      style = ''
        ${builtins.readFile ./style.css}
      '';
    };
  };
}
