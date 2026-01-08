# Dev module options
# All option definitions for dot.home.dev.*
{ lib, ... }:
{
  options.dot.home.dev = {
    enable = lib.mkEnableOption "development tools";

    vscode = {
      enable = lib.mkEnableOption "VS Code editor";
    };

    jetbrains = {
      enable = lib.mkEnableOption "JetBrains IDE configuration";
    };

    mise = {
      enable = lib.mkEnableOption "mise version manager";
    };

    ai = {
      enable = lib.mkEnableOption "AI coding assistants (common packages)";

      claude = {
        enable = lib.mkEnableOption "Claude Code AI assistant";
      };

      codex = {
        enable = lib.mkEnableOption "Codex AI assistant";
      };

      gemini = {
        enable = lib.mkEnableOption "Gemini AI assistant";
      };
    };
  };
}
