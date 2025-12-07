{ pkgs, ... }:
{
  imports = [
    ../.
  ];
  home.packages = with pkgs; [
    gemini-cli-bin
  ];

  home.file.".gemini/settings.json" = {
    source =
      let
        cfg = builtins.replaceStrings [ "@@GITHUB_TOKEN@@" ] [ (builtins.getEnv "GITHUB_TOKEN") ] (
          builtins.readFile ./settings.json
        );
      in
      pkgs.writeText "settings.json" cfg;
  };
}
