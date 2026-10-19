{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dot.home.apps;
in
{
  config = lib.mkIf cfg.darwin.enable {
    home.packages =
      with pkgs;
      [
        pngpaste
        # Managed as a Homebrew cask in nix-darwin. Home Manager's copyApps
        # restores the pinned Nix version on each switch, which can leave
        # Raycast's database newer than the app after Raycast updates itself.
        # raycast

      ]
      ++ (with pkgs.brewCasks; [
        spaceid
        fork
        openlogi
      ]);
  };
}
