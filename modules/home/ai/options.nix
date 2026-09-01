# AI module options
# All option definitions for dot.home.ai.*
{ lib, ... }:
{
  options.dot.home.ai = {
    enable = lib.mkEnableOption "AI assistant configuration";

    claude = {
      enable = lib.mkEnableOption "Claude Code AI assistant";
    };

    codex = {
      enable = lib.mkEnableOption "Codex AI assistant";
    };

    codexDesktop = {
      enable = lib.mkEnableOption "Codex Desktop for Linux (Electron)";
    };

    opencode = {
      enable = lib.mkEnableOption "OpenCode AI assistant";

      otel.endpoint = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = "http://Cipher:4318";
        description = ''
          OTLP HTTP endpoint that opencode exports traces and logs to
          (`OTEL_EXPORTER_OTLP_ENDPOINT`). Points at Cipher's Alloy receiver.
          Set to `null` to keep telemetry local to the machine.
        '';
      };
    };

    agy = {
      enable = lib.mkEnableOption "Antigravity AI assistant";
    };

    pi = {
      enable = lib.mkEnableOption "Pi coding agent";
    };

    orca = {
      enable = lib.mkEnableOption "Orca AI orchestrator";
    };
  };
}
