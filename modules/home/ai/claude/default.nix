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

  config = lib.mkIf cfg.claude.enable {
    programs.jq.enable = true;
    programs.claude-code = {
      enable = true;
      package = inputs.llm-agents-nix.packages.${pkgs.stdenv.hostPlatform.system}.claude-code;
    };

    programs.zsh.zsh-abbr.abbreviations = {
      "c" = "claude";
    };

    home.file.".local/bin/claude".source = "${config.programs.claude-code.package}/bin/claude";
    home.file.".claude/settings.json".source = ./settings.json;
    home.file.".claude/CLAUDE.md".source = ./CLAUDE.md;
    home.file.".claude/hooks/on-cwd-changed.sh" = {
      source = ./hooks/on-cwd-changed.sh;
      executable = true;
    };
    home.file.".claude/hooks/on-env-changed.sh" = {
      source = ./hooks/on-env-changed.sh;
      executable = true;
    };
  };
}
