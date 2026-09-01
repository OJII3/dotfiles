{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dot.home.ai;
  orca = pkgs.callPackage ./package.nix { };
in
{
  config = lib.mkIf (cfg.enable && cfg.orca.enable) {
    home.packages = [ orca ];

    # LaunchServices does not reliably discover app bundles left in the Nix
    # profile. Keep the CLI in the profile, but copy the GUI app to the
    # conventional Home Manager applications directory on macOS.
    home.activation = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
      orcaApplication = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        appDirectory=${lib.escapeShellArg "${config.home.homeDirectory}/Applications/Home Manager Apps"}
        appPath="$appDirectory/Orca.app"

        mkdir -p "$appDirectory"
        if [ -e "$appPath" ] || [ -L "$appPath" ]; then
          rm -rf "$appPath"
        fi
        /usr/bin/ditto ${lib.escapeShellArg "${orca}/Applications/Orca.app"} "$appPath"
      '';
    };
  };
}
