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
  config = lib.mkIf (cfg.enable && cfg.dsh.enable) {
    home.packages = [
      inputs.llm-agents-nix.packages.${pkgs.stdenv.hostPlatform.system}.dsh
    ];
  };
}
