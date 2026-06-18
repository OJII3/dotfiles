{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dot.home.ai;
  commonPackages =
    with pkgs;
    [
      bun
      uv
      (callPackage ../../../packages/gwq.nix { })
    ]
    ++ lib.lists.optionals (pkgs.stdenv.hostPlatform.isDarwin) [
      terminal-notifier
    ]
    ++ lib.lists.optionals (pkgs.stdenv.hostPlatform.isLinux) [
      libnotify
    ];
in
{
  config = lib.mkIf cfg.opencode.enable {
    home.packages = commonPackages;
    programs.opencode = {
      enable = true;
      context = ./AGENTS.md;
      package = inputs.llm-agents-nix.packages.${pkgs.stdenv.hostPlatform.system}.opencode;
    };
    home.file.".config/opencode/agents" = {
      source = ./agents;
      recursive = true;
    };
  };
}
