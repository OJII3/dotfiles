{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dot.home.ai;
in
{
  config = lib.mkIf cfg.pi.enable {
    home.packages = [
      inputs.llm-agents-nix.packages.${pkgs.stdenv.hostPlatform.system}.pi
    ];

    home.file.".pi/agent/AGENTS.md".source = ./AGENTS.md;
  };
}
