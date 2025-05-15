{ pkgs, lib, ... }:
let
  extra-path = with pkgs; [
    # Add any extra binaries you want accessible to Rider here
    dotnet-sdk
  ];

  extra-lib = with pkgs;[
    # Add any extra libraries you want accessible to Rider here
  ];

  rider = pkgs.jetbrains.rider.overrideAttrs (attrs: {
    postInstall = ''
      # Wrap rider with extra tools and libraries
      mv $out/bin/rider $out/bin/.rider-toolless
      makeWrapper $out/bin/.rider-toolless $out/bin/rider \
        --argv0 rider \
        --prefix PATH : "${lib.makeBinPath extra-path}" \
        --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath extra-lib}"

      # Making Unity Rider plugin work!
      # The plugin expects the binary to be at /rider/bin/rider,
      # with bundled files at /rider/
      # It does this by going up two directories from the binary path
      # Our rider binary is at $out/bin/rider, so we need to link $out/rider/ to $out/
      shopt -s extglob
      ln -s $out/rider/!(bin) $out/
      shopt -u extglob
    '' + attrs.postInstall or "";
  });
in
{

  home.packages = with pkgs; [
    unityhub
    rider
  ];

  home.file.".local/share/JetBrains/Toolbox/apps/rider" = {
    source = "${pkgs.jetbrains.rider}/rider";
    recursive = true;
  };
}
