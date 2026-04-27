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

    # 非 NixOS (Ubuntu 等) では Nix store 内の Electron/Chromium アプリが
    # SUID sandbox を使えない。AppArmor の unprivileged userns 制限を解除する
    # 必要があるが、sysctl には root 権限が要るため activation で警告だけ出す。
    home.activation.checkUnprivilegedUserns = lib.mkIf config.targets.genericLinux.enable (
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        val="$(cat /proc/sys/kernel/apparmor_restrict_unprivileged_userns 2>/dev/null || echo 0)"
        if [ "$val" = "1" ]; then
          echo ""
          echo "[WARNING] kernel.apparmor_restrict_unprivileged_userns = 1"
          echo "Electron/Chromium apps from Nix store will fail with SUID sandbox errors."
          echo "Run the following to fix:"
          echo "  echo 'kernel.apparmor_restrict_unprivileged_userns=0' | sudo tee /etc/sysctl.d/99-nix-userns.conf && sudo sysctl --system"
          echo ""
        fi
      ''
    );

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
