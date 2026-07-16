{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dot.darwin.core;
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      vim
      git
      gnumake
      python312
    ];
  };
}
