# macOS (Darwin) specific apps for home-manager
# Most Apps and Services are declared in nix-darwin configuration
# This is because permissions are linked to binaries in nix directory,
# which means if hash changes, permissions need to be re-granted.
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    pngpaste
  ];
}
