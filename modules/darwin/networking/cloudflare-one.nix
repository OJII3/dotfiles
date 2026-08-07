{ config, lib, ... }:
let
  cfg = config.dot.darwin.networking;
in
{
  config = lib.mkIf (cfg.enable && cfg.cloudflareOne.enable) {
    assertions = [
      {
        assertion = config.homebrew.enable;
        message = "dot.darwin.networking.cloudflareOne requires homebrew to be enabled (set dot.darwin.core.enable = true)";
      }
    ];
    # nixpkgs の cloudflare-warp は .app をコピーするだけで、warp-cli が話す
    # LaunchDaemon と Network System Extension を登録しない。cask は公式 .pkg を
    # 実行するのでそれらが入る。
    homebrew.casks = [ "cloudflare-warp" ];
  };
}
