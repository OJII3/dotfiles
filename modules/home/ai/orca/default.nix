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
  orcaPackage = inputs.llm-agents-nix.packages.${pkgs.stdenv.hostPlatform.system}.orca;
  orcaServe = pkgs.writeShellScript "orca-serve" ''
    set -euo pipefail

    pairing_address="$(${pkgs.iproute2}/bin/ip -4 -o addr show dev CloudflareWARP 2>/dev/null \
      | ${pkgs.gawk}/bin/awk '{ split($4, address, "/"); print address[1]; exit }' \
      || true)"
    if [ -z "$pairing_address" ]; then
      echo "Cloudflare WARP interface has no IPv4 address" >&2
      exit 1
    fi

    exec ${orcaPackage}/bin/orca serve \
      --port 6768 \
      --pairing-address "$pairing_address" \
      --json
  '';
in
{
  config = lib.mkIf (cfg.enable && cfg.orca.enable) {
    assertions = [
      {
        assertion = isLinux;
        message = "dot.home.ai.orca.enable is only supported on Linux.";
      }
    ];

    home.packages = lib.optionals isLinux [ orcaPackage ];

    systemd.user.services.orca = lib.mkIf isLinux {
      Unit.Description = "Orca remote runtime";
      Service = {
        Type = "simple";
        WorkingDirectory = config.home.homeDirectory;
        Environment = [ "LIBGL_ALWAYS_SOFTWARE=1" ];
        ExecStart = "${orcaServe}";
        KillMode = "mixed";
        Restart = "on-failure";
        RestartPreventExitStatus = 3;
        RestartSec = 5;
      };
      Install.WantedBy = [ "default.target" ];
    };
  };
}
