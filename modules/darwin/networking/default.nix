{ ... }:
{
  imports = [
    ./options.nix
    ./base.nix
    ./tailscale.nix
    ./openssh.nix
    ./cloudflared.nix
  ];
}
