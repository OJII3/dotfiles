{
  appimageTools,
  fetchurl,
  lib,
  stdenv,
  stdenvNoCC,
  undmg,
}:

let
  version = "1.4.192";
  sources = {
    "x86_64-linux" = {
      url = "https://github.com/stablyai/orca/releases/download/v${version}/orca-linux.AppImage";
      hash = "sha256-kAPnjGwCh8UXNWm8kVKdpKmWOy1CRf0jcBZReZq8p3w=";
    };
    "aarch64-linux" = {
      url = "https://github.com/stablyai/orca/releases/download/v${version}/orca-linux-arm64.AppImage";
      hash = "sha256-hLCIjFWHup1/3EnuP73sdydeGeocZs2sI+YYIMiHPa8=";
    };
    "x86_64-darwin" = {
      url = "https://github.com/stablyai/orca/releases/download/v${version}/orca-macos-x64.dmg";
      hash = "sha256-2JJupBUaMCKSslUAiIbS55fqBT8SrXxgG0cvP1mwGQs=";
    };
    "aarch64-darwin" = {
      url = "https://github.com/stablyai/orca/releases/download/v${version}/orca-macos-arm64.dmg";
      hash = "sha256-yNZhmS596JLH7yV8SMDo+zz3RBv0IkDbAPtyCYJiQz4=";
    };
  };
  src = fetchurl sources.${stdenv.hostPlatform.system};
  commonMeta = {
    description = "AI orchestrator for working with a fleet of parallel agents";
    homepage = "https://www.onorca.dev/";
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
in
if stdenv.hostPlatform.isLinux then
  appimageTools.wrapType2 rec {
    pname = "orca";
    inherit version src;

    appimageContents = appimageTools.extract { inherit pname version src; };

    extraInstallCommands = ''
      install -Dm444 ${appimageContents}/orca-ide.desktop $out/share/applications/orca.desktop
      install -Dm444 ${appimageContents}/usr/share/icons/hicolor/512x512/apps/orca-ide.png \
        $out/share/icons/hicolor/512x512/apps/orca.png
      substituteInPlace $out/share/applications/orca.desktop \
        --replace-fail 'Exec=AppRun --no-sandbox %U' 'Exec=orca %U' \
        --replace-fail 'Icon=orca-ide' 'Icon=orca'
    '';

    # `orca serve` starts Xvfb itself when DISPLAY is unset. The other tools
    # are used by the headless runtime and are not guaranteed to be present on
    # a minimal server installation.
    extraPkgs =
      pkgs: with pkgs; [
        cacert
        curl
        file
        git
        jq
        xvfb
      ];

    meta = commonMeta // {
      platforms = lib.platforms.linux;
      mainProgram = "orca";
    };
  }
else if stdenv.hostPlatform.isDarwin then
  stdenvNoCC.mkDerivation {
    pname = "orca";
    inherit version src;

    nativeBuildInputs = [ undmg ];
    sourceRoot = ".";

    installPhase = ''
      runHook preInstall

      mkdir -p "$out/Applications" "$out/bin"
      cp -R Orca.app "$out/Applications/"
      ln -s "$out/Applications/Orca.app/Contents/Resources/bin/orca" "$out/bin/orca"

      runHook postInstall
    '';

    meta = commonMeta // {
      platforms = lib.platforms.darwin;
      mainProgram = "orca";
    };
  }
else
  throw "orca is not supported on ${stdenv.hostPlatform.system}"
