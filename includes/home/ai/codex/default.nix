{ pkgs, ... }:
{
  home.packages = with pkgs; [
    codex

    # for local mcp servers
    bun
    uv
  ];
  # home.file.".codex/config.toml".text = ''
  #   [profiles.full_auto]
  #   approval_policy = "on-request"
  #   sandbox_mode    = "workspace-write"
  #
  #   [profiles.readonly_quiet]
  #   approval_policy = "never"
  #   sandbox_mode    = "read-only"
  #
  #
  #   network_access = true
  #
  #
  #   [mcp_servers.arxiv]
  #   command = "nix shell nixpkgs#uv --command uvx"
  #   args = ["arxiv-mcp-server"]
  #
  #   [mcp_servers.context7]
  #   command = "nix shell nixpkgs#bun --command bunx"
  #   args = ["-y", "@upstash/context7-mcp"]
  #
  #   [mcp_servers.voicevox]
  #   command = "nix shell nixpkgs#bun --command bunx"
  #   args = ["-y", "@upstash/voicevox-mcp"]
  #
  #   [mcp_servers.figma]
  #   command = "nix shell nixpkgs#bun --command bunx"
  #   args = ["-y", "mcp-remote", "http://127.0.0.1:3845/mcp"]
  # '';
}
