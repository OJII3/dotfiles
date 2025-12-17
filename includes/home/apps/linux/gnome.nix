{ pkgs, ... }:
{
  imports = [ ./common.nix ];
  home.packages = with pkgs; [
  ];
  programs.vscode.enable = true;
}
