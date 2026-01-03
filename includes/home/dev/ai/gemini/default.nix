{ pkgs, ... }:
{
  imports = [
    ../common.nix
  ];
  home.packages = with pkgs; [
    gemini-cli-bin
  ];

  home.file.".gemini/settings.json".source = ./settings.json;
  home.file.".gemini/AGENTS.md".source = ./AGENTS.md;
}
