# Most Apps and Services are declared in nix-darwin configuration
# This is because permissions are linked to binaries in nix directory,
# which means if hash changes, permissions need to be re-granted.
{ pkgs, ... }:
{
  imports = [
    ./common.nix
  ];

  home.packages =
    with pkgs;
    [
      terminal-notifier
      raycast
    ]
    ++ (with pkgs.brewCasks; [
      pngpaste

      (unity-hub.overrideAttrs (oldAttrs: {
        src = pkgs.fetchurl {
          url = builtins.head oldAttrs.src.urls;
          hash = "sha256-fiF5NxZLzNv/x4e83HV/OI2UrgFY6jL4YPExU53SWok=";
        };
      }))
    ]);
}
