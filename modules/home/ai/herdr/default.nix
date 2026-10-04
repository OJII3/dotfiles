{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dot.home.ai;
  herdr = inputs.llm-agents-nix.packages.${pkgs.stdenv.hostPlatform.system}.herdr;
in
{
  config = lib.mkIf (cfg.enable) {
    home.packages = [ herdr ];

    home.file.".config/herdr/config.toml".source = ./config.toml;
  };
}
