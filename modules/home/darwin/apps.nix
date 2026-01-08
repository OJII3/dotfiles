{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dot.home.darwin.apps;
in
{
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      pngpaste
      chatgpt
    ];
  };
}
