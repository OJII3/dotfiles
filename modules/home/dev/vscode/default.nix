{ config, lib, ... }:
let
  cfg = config.dot.home.dev;
in
{
  config = lib.mkIf cfg.vscode.enable {
    programs.vscode = {
      enable = true;
    };
  };
}
