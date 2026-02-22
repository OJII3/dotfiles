{
  lib,
  stdenv,
  fetchzip,
  autoPatchelfHook,
  makeWrapper,
  zlib,
  libGL,
  libxkbcommon,
  xkeyboard_config,
  wayland,
  fontconfig,
  freetype,
  dbus,
  glib,
  libx11,
  libxext,
  libxrender,
  libxcb,
  libxi,
  libxcursor,
  libxfixes,
  libxrandr,
  libxcomposite,
  libxdamage,
  libxtst,
  xcbutilcursor,
  xcbutilwm,
  xcbutilimage,
  xcbutilkeysyms,
  xcbutilrenderutil,
  libxscrnsaver,
}:

stdenv.mkDerivation rec {
  pname = "blender-launcher-v2";
  version = "2.5.3";

  src = fetchzip {
    url = "https://github.com/Victor-IX/Blender-Launcher-V2/releases/download/v${version}/Blender_Launcher_v${version}_Linux_x64.zip";
    hash = "sha256-+g3kMsMjLt51Mec0peTVxKILEy8kzi4Dr+8937KiQuw=";
    stripRoot = false;
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    stdenv.cc.cc.lib
    zlib
  ];

  runtimeDependencies = [
    libGL
    libxkbcommon
    wayland
    fontconfig
    freetype
    dbus
    glib
    libx11
    libxext
    libxrender
    libxcb
    libxi
    libxcursor
    libxfixes
    libxrandr
    libxcomposite
    libxdamage
    libxtst
    libxscrnsaver
    xcbutilcursor
    xcbutilwm
    xcbutilimage
    xcbutilkeysyms
    xcbutilrenderutil
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib $out/share/applications $out/share/icons/hicolor/128x128/apps

    cp "dist/release/Blender Launcher" $out/lib/blender-launcher

    install -Dm644 extras/blenderlauncher.desktop $out/share/applications/blenderlauncher.desktop
    install -Dm644 source/resources/icons/bl/bl_128.png $out/share/icons/hicolor/128x128/apps/blenderlauncher.png

    substituteInPlace $out/share/applications/blenderlauncher.desktop \
      --replace-fail "/usr/bin/blenderlauncher" "$out/bin/blender-launcher" \
      --replace-fail "Icon=blenderlauncher" "Icon=$out/share/icons/hicolor/128x128/apps/blenderlauncher.png"

    makeWrapper $out/lib/blender-launcher $out/bin/blender-launcher \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeDependencies}" \
      --set XKB_CONFIG_ROOT "${xkeyboard_config}/share/X11/xkb"

    runHook postInstall
  '';

  # PyInstaller bundles extract .so files at runtime; they need the patched libs via LD_LIBRARY_PATH
  autoPatchelfIgnoreMissingDeps = [
    "libcrypt.so.1"
  ];

  meta = {
    description = "Blender build manager for downloading and managing Blender versions";
    homepage = "https://github.com/Victor-IX/Blender-Launcher-V2";
    license = lib.licenses.gpl3Only;
    mainProgram = "blender-launcher";
    platforms = [ "x86_64-linux" ];
  };
}
