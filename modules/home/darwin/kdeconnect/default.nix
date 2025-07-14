{ pkgs, lib, ... }:
let
  kdeconnect-macos = pkgs.stdenv.mkDerivation {
    pname = "kdeconnect-macos";
    version = "master-5196";

    src = pkgs.fetchurl {
      url = "https://cdn.kde.org/ci-builds/network/kdeconnect-kde/master/macos-arm64/kdeconnect-kde-master-5196-macos-clang-arm64.dmg";
      sha256 = "sha256-q4hbWJJNYsF2YjGguTdb+gwg7FxUpZ9LHlriWNfCKpM=";
    };

    nativeBuildInputs = with pkgs; [ undmg ];

    sourceRoot = ".";

    installPhase = ''
      runHook preInstall
      
      mkdir -p $out/Applications
      mkdir -p $out/bin
      cp -r "KDE Connect.app" $out/Applications/
      
      runHook postInstall
    '';

    meta = with lib; {
      description = "KDE Connect for macOS - Connect your devices";
      homepage = "https://kdeconnect.kde.org/";
      license = licenses.gpl2Plus;
      platforms = platforms.darwin;
      maintainers = [ ];
    };
  };
in
{
  home.packages = [
    kdeconnect-macos
  ];

  # Create a launcher script for easier access
  home.file."Applications/KDE Connect.app" = {
    source = "${kdeconnect-macos}/Applications/KDE Connect.app";
    recursive = true;
  };
}
