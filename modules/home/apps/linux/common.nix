{
  config,
  lib,
  pkgs,
  pkgs-stable,
  ...
}:
let
  cfg = config.dot.home.apps.linux;
in
{
  config = lib.mkIf cfg.common.enable {
    home.packages = with pkgs; [
      (bottles.override { removeWarningPopup = true; })
      discord
      figma-linux
      gimp
      hunspell
      inkscape-with-extensions
      moonlight-qt
      mpv
      p7zip
      pkgs-stable.blender
      slack
      unityhub
      vlc
      voicevox
    ];

    # Unity Hub の Android NDK インストール時、extractedPathRename で
    # android-ndk-<ver>/ の中身が NDK/ 直下に移動されるが、NDK 内部の 35+ 個
    # の絶対パス symlink は android-ndk-<ver>/... を指したまま壊れる。
    # `android-ndk-<ver>` を `.` への symlink として作り直して救済する。
    home.activation.unityNdkRepair = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      set -eu
      for ndk_dir in "$HOME"/Unity/Hub/Editor/*/Editor/Data/PlaybackEngines/AndroidPlayer/NDK; do
        [ -d "$ndk_dir" ] || continue
        needed="$(find "$ndk_dir" -xtype l -printf '%l\n' 2>/dev/null \
          | grep -oE 'android-ndk-[^/]+' \
          | sort -u || true)"
        [ -z "$needed" ] && continue
        while IFS= read -r v; do
          [ -z "$v" ] && continue
          link="$ndk_dir/$v"
          if [ ! -e "$link" ]; then
            rm -f "$link"
            ln -s . "$link"
            echo "[unity-ndk-repair] $link -> ."
          fi
        done <<< "$needed"
      done
    '';

    programs = {
      obs-studio.enable = true;
      google-chrome = {
        enable = pkgs.stdenv.hostPlatform.system == "x86_64-linux";
        commandLineArgs = [
          "--ozone-platform-hint=auto"
          "--enable-wayland-ime"
        ];
      };
      vivaldi = {
        enable = true;
        commandLineArgs = [
          "--ozone-platform-hint=auto"
          "--enable-wayland-ime"
        ];
      };
    };
  };
}
