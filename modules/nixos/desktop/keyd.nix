# keyd key remapping configuration
{ config, lib, ... }:
let
  cfg = config.dot.desktop;
in
{
  config = lib.mkIf (cfg.enable && cfg.keyd.enable) {
    services.keyd = {
      enable = true;
      keyboards = {
        "*" = {
          settings = {
            main = {
              capslock = "overload(control, esc)";
              space = "overload(meta, space)";
              muhenkan = "overload(meta, space)";
              rightalt = "overload(rightalt, hiragana_katakana)";
            };
          };
        };
      };
    };
  };
}
