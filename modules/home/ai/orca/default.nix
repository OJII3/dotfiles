{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dot.home.ai;
  isLinux = pkgs.stdenv.hostPlatform.isLinux;
in
{
  config = lib.mkIf (cfg.enable && cfg.orca.enable) {
    assertions = [
      {
        assertion = isLinux;
        message = "dot.home.ai.orca.enable is only supported on Linux.";
      }
    ];

    home.packages = lib.optionals isLinux [
      inputs.llm-agents-nix.packages.${pkgs.stdenv.hostPlatform.system}.orca
    ];
  };
}
