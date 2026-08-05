# Hammerspoon configuration
# Applied when dot.darwin.desktop.hammerspoon.enable is true
#
# CapsLock を tap=Esc / hold=Ctrl にするための darwin 側の下ごしらえ:
#   1. CapsLock -> Control の OS レベルリマップ (hidutil、ドライバ不要)
#   2. Hammerspoon.app のインストール
# tap 判定のロジックは home-manager 側の ~/.hammerspoon/init.lua が担当する。
{ config, lib, ... }:
let
  cfg = config.dot.darwin.desktop;
in
{
  config = lib.mkIf (cfg.enable && cfg.hammerspoon.enable) {
    assertions = [
      {
        assertion = config.homebrew.enable;
        message = "dot.darwin.desktop.hammerspoon requires homebrew to be enabled (set dot.darwin.core.enable = true)";
      }
    ];

    # nixpkgs 経由だと rebuild のたびに実体パスが変わり Accessibility 権限が
    # 外れうるため、GUI アプリは Homebrew cask で入れる。
    homebrew.casks = [ "hammerspoon" ];

    # system.keyboard.enableKeyMapping は ./base.nix が設定済み (再定義しない)。
    system.keyboard.remapCapsLockToControl = true;
  };
}
