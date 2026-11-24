{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dot.home.ai;
in
{
  config = lib.mkIf (cfg.enable && cfg.orca.enable) {
    home.packages = [
      inputs.llm-agents-nix.packages.${pkgs.stdenv.hostPlatform.system}.orca
    ];
  };
}
